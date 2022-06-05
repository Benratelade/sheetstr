# frozen_string_literal: true

require "rails_helper"

RSpec.describe Timesheets::LineItemsController, type: :controller do
  before do
    @current_user = double("current user")
    allow(controller).to receive(:current_user).and_return(@current_user)
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
      params = ActionController::Parameters.new(
        weekday: "some day",
        description: "some description",
        start_time: "a start time",
        end_time: "an end time",
        hourly_rate: "an hourly rate",
      ).permit!
      expect(@timesheet).to receive(:line_items).and_return(@line_items)
      expect(@line_items).to receive(:new).with(params).and_return(@line_item)

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
end
