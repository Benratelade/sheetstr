# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheets::LineItemsController, type: :controller do
  before do
    @current_user = double("current user")
    allow(controller).to receive(:current_user).and_return(@current_user)

    @timesheets_association = double("timesheets association")
    allow(@current_user).to receive(:timesheets).and_return(@timesheets_association)
    @timesheet = double("timesheet", id: "timesheet-id")
    allow(@timesheets_association).to receive(:find).and_return(@timesheet)

    @line_item = double("line item", id: "line-item-id")
    @line_items_association = double("line items association")
    allow(@timesheet).to receive(:line_items).and_return(@line_items_association)
    allow(@line_items_association).to receive(:find).and_return(@line_item)
  end

  describe "GET #new" do
    before do
      @timesheets = double("some timesheets")
      @timesheet = double("a timesheet", id: "timesheet-id")
      allow(@current_user).to receive(:timesheets).and_return(@timesheets)
      allow(@timesheets).to receive(:find).and_return(@timesheet)
    end

    it "assigns the timesheet" do
      expect(@current_user).to receive(:timesheets).and_return(@timesheets)
      expect(@timesheets).to receive(:find).with("timesheet-id").and_return(@timesheet)

      get :new, params: { timesheet_id: "timesheet-id" }

      expect(assigns(:timesheet)).to eq(@timesheet)
    end

    it "assigns a new line item" do
      line_item = double("line item")
      expect(LineItem).to receive(:new).with(timesheet_id: @timesheet.id).and_return(line_item)
      get :new, params: { timesheet_id: "timesheet-id" }

      expect(assigns(:line_item)).to eq(line_item)
    end
  end

  describe "POST #create" do
    before do
      @timesheets = double("some timesheets")
      @timesheet = double("a timesheet", id: "timesheet-id")
      @line_item = double("a line item")
      @line_items = double("some line items")
      allow(@current_user).to receive(:timesheets).and_return(@timesheets)
      allow(@timesheets).to receive(:find).and_return(@timesheet)
      allow(@timesheet).to receive(:line_items).and_return(@line_items)
      allow(@line_items).to receive(:new).and_return(@line_item)
      allow(@line_item).to receive(:save)
    end

    it "assigns the timesheet" do
      expect(@current_user).to receive(:timesheets).and_return(@timesheets)
      expect(@timesheets).to receive(:find).with("timesheet-id").and_return(@timesheet)

      post :create, params: {
        timesheet_id: "timesheet-id",
        line_item: {
          weekday: "some day",
          description: "some description",
          start_time: "a start time",
          end_time: "an end time",
          hourly_rate: "an hourly rate",
        },
      }

      expect(assigns(:timesheet)).to eq(@timesheet)
    end

    it "creates and assigns a new line item based on the params" do
      expect(@timesheet).to receive(:line_items).and_return(@line_items)
      expect(@line_items).to receive(:new).with(
        {
          "weekday" => "some day",
          "description" => "some description",
          "start_time" => "a start time",
          "end_time" => "an end time",
          "hourly_rate" => "an hourly rate",
        },
      ).and_return(@line_item)

      post :create, params: {
        timesheet_id: "timesheet-id",
        line_item: {
          weekday: "some day",
          description: "some description",
          start_time: "a start time",
          end_time: "an end time",
          hourly_rate: "an hourly rate",
        },
      }

      expect(assigns(:line_item)).to eq(@line_item)
    end

    context "when the line item is valid" do
      it "redirects to the timesheet" do
        allow(@line_item).to receive(:save).and_return(true)

        post :create, params: {
          timesheet_id: "timesheet-id",
          line_item: {
            weekday: "some day",
            description: "some description",
            start_time: "a start time",
            end_time: "an end time",
            hourly_rate: "an hourly rate",
          },
        }

        expect(response).to redirect_to("/timesheets/timesheet-id")
      end
    end

    context "when the line item is NOT valid" do
      it "renders the new method" do
        allow(@line_item).to receive(:save).and_return(false)

        post :create, params: {
          timesheet_id: "timesheet-id",
          line_item: {
            weekday: "some day",
            description: "some description",
            start_time: "a start time",
            end_time: "an end time",
            hourly_rate: "an hourly rate",
          },
        }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the timesheet and the line item" do
      expect(@current_user).to receive(:timesheets)
      expect(@timesheets_association).to receive(:find).with("timesheet-id")
      expect(@line_items_association).to receive(:find).with("line-item-id")

      get :edit, params: { timesheet_id: "timesheet-id", id: "line-item-id" }

      expect(assigns(:line_item)).to eq(@line_item)
      expect(assigns(:timesheet)).to eq(@timesheet)
    end

    it "returns 200" do
      get :edit, params: { timesheet_id: "timesheet-id", id: "line-item-id" }

      expect(response).to have_http_status("200")
    end

    it "renders the edit view" do
      get :edit, params: { timesheet_id: "timesheet-id", id: "line-item-id" }

      expect(response).to render_template(:edit)
    end

    context "some records are not found" do
      it "renders a 404 not found when the timesheet isn't found" do
        allow(@timesheets_association).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

        expect do
          get :edit, params: { timesheet_id: "timesheet-id", id: "line-item-id" }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "renders a 404 not found when the line item isn't found" do
        allow(@line_items_association).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

        expect do
          get :edit, params: { timesheet_id: "timesheet-id", id: "line-item-id" }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "PATCH #update" do
    before do
      allow(@line_item).to receive(:update).and_return(true)
    end

    it "assigns the timesheet and the line item" do
      expect(@current_user).to receive(:timesheets)
      expect(@timesheets_association).to receive(:find).with("timesheet-id")
      expect(@line_items_association).to receive(:find).with("line-item-id")

      patch :update, params: {
        timesheet_id: "timesheet-id",
        id: "line-item-id",
        line_item: {
          foo: "bar",
        },
      }

      expect(assigns(:line_item)).to eq(@line_item)
      expect(assigns(:timesheet)).to eq(@timesheet)
    end

    it "updates the line item with permitted params" do
      expect(@line_item).to receive(:update).with(
        {
          "weekday" => "weekday",
          "description" => "description",
          "start_time" => "start time",
          "end_time" => "end time",
          "hourly_rate" => "hourly rate",
        },
      )

      patch :update, params: {
        id: "line-item-id",
        timesheet_id: "timesheet-id",
        line_item: {
          weekday: "weekday",
          description: "description",
          start_time: "start time",
          end_time: "end time",
          hourly_rate: "hourly rate",
          not_permitted: "nope",
        },
      }
    end

    it "sets the flash and redirects to the timesheet" do
      patch :update, params: {
        timesheet_id: "timesheet-id",
        id: "line-item-id",
        line_item: {
          foo: "bar",
        },
      }

      expect(flash[:notice]).to eq("Line item was updated")
      expect(response).to redirect_to(timesheet_url(@timesheet.id))
    end
  end
end
