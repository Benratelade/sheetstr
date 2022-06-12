# frozen_string_literal: true

require "rails_helper"

RSpec.describe TimesheetsController, type: :controller do
  describe "#new" do
    it "creates a new Timesheet where start_date is the Monday of the current week" do
      Timecop.freeze(Date.parse("Feb 05 2022"))

      expect(Timesheet).to receive(:new).with(
        start_date: Date.parse("Jan 31 2022"),
        end_date: Date.parse("Feb 06 2022"),
      ).and_call_original
      get :new
    end

    it "instantiates one line item for each date in the range" do
      Timecop.freeze(Date.parse("Feb 05 2022"))
      timesheet = double(
        "A timesheet",
        line_items: [],
        start_date: Date.parse("Jan 31 2022"),
        end_date: Date.parse("Feb 06 2022"),
      )

      expect(Timesheet).to receive(:new).with(
        start_date: Date.parse("Jan 31 2022"),
        end_date: Date.parse("Feb 06 2022"),
      ).and_return(timesheet)

      expect(LineItem).to receive(:new).exactly(7).times

      get :new

      expect(timesheet.line_items.count).to eq(7)
    end

    it "sets the start_time on all associated line_items" do
      Timecop.freeze(Date.parse("Feb 05 2022"))

      get :new

      expect(assigns(:timesheet).line_items[0].start_time).to eq("Mon, 31 Jan 2022")
      expect(assigns(:timesheet).line_items[1].start_time).to eq("Tue, 01 Feb 2022")
      expect(assigns(:timesheet).line_items[2].start_time).to eq("Wed, 02 Feb 2022")
      expect(assigns(:timesheet).line_items[3].start_time).to eq("Thu, 03 Feb 2022")
      expect(assigns(:timesheet).line_items[4].start_time).to eq("Fri, 04 Feb 2022")
      expect(assigns(:timesheet).line_items[5].start_time).to eq("Sat, 05 Feb 2022")
      expect(assigns(:timesheet).line_items[6].start_time).to eq("Sun, 06 Feb 2022")
    end

    it "renders the new Timesheet template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    before do
      @current_user = User.create!(email: "bob@sheetstr.com", password: "password")
      allow(controller).to receive(:current_user).and_return(@current_user)
      @timesheet = double(
        "A timesheet",
        to_model: double(
          "to_model",
          model_name: double(
            "model_name",
            name: Timesheet,
            singular_route_key: "timesheet",
          ),
          persisted?: true,
        ),
      )
      allow(@timesheet).to receive(:save).and_return(true)
    end

    it "adds the new timesheet to the current user's timesheets" do
      timesheet_params = {
        timesheet: {
          start_date: double("start date"),
          end_date: double("end date"),
        },
      }
      allow(controller).to receive(:timesheet_params).and_return(timesheet_params)
      expect(timesheet_params).to receive(:merge).with(user: @current_user)

      post :create, params: timesheet_params
    end

    it "saves the new timesheet record to the database" do
      expect(Timesheet).to receive(:new).and_return(@timesheet)
      expect(@timesheet).to receive(:save)

      post :create, params: {
        timesheet: {
          start_date: double("Start date"),
          end_date: double("End date"),
        },
      }
    end

    it "assigns a @timesheet record" do
      post :create, params: { timesheet: { start_date: Date.parse("24 Jan 2022") } }
      expect(assigns(:timesheet)).to be_a(Timesheet)
    end

    it "correctly sets the start_date and end_date" do
      start_date = Date.parse("24 Jan 2022")
      end_date = Date.parse("24 Jan 2022")
      post :create, params: { timesheet: {
        start_date: Date.parse("24 Jan 2022"),
        end_date: Date.parse("24 Jan 2022"),
      } }
      expect(assigns(:timesheet).start_date).to eq(start_date)
      expect(assigns(:timesheet).end_date).to eq(end_date)
    end

    it "redirects to a #show action" do
      timesheet = double(
        "A timesheet",
        id: "the_timesheet_id",
        model_name: double(
          "model name",
          name: "Timesheet",
          singular: "timesheet",
          singular_route_key: "timesheet",
        ),
        to_param: "the_timesheet_id",
        persisted?: true,
      )
      allow(timesheet).to receive(:to_model).and_return(timesheet)
      allow(@current_user).to receive(:timesheets).and_return([timesheet])
      expect(Timesheet).to receive(:new).and_return(timesheet)
      expect(timesheet).to receive(:save).and_return(true)

      post :create, params: {
        timesheet: {
          start_date: Date.parse("24 Jan 2022"),
          end_date: Date.parse("31 Jan 2022"),
        },
      }

      expect(response).to redirect_to("/timesheets/the_timesheet_id")
    end

    it "saves the associated timesheet line items if there are any" do
      Timecop.freeze(Date.parse("Feb 05 2022"))

      params = {
        timesheet: {
          start_date: Date.parse("Jan 31 2022"),
          end_date: Date.parse("Feb 06 2022"),
          line_items_attributes: {
            "0" => {
              start_time: Time.zone.parse("Jan 31 2022 08:00am"),
              end_time: Time.zone.parse("Jan 31 2022 17:00pm"),
              hourly_rate: 21,
            },
            "1" => {
              start_time: Time.zone.parse("Feb 01 2022 08:00am"),
              end_time: Time.zone.parse("Feb 01 2022 17:00pm"),
              hourly_rate: 21,
            },
            "2" => {
              start_time: Time.zone.parse("Feb 02 2022 08:00am"),
              end_time: Time.zone.parse("Feb 02 2022 17:00pm"),
              hourly_rate: 21,
            },
            "3" => {
              start_time: Time.zone.parse("Feb 03 2022 08:00am"),
              end_time: Time.zone.parse("Feb 03 2022 17:00pm"),
              hourly_rate: 21,
            },
            "4" => {
              start_time: Time.zone.parse("Feb 04 2022 08:00am"),
              end_time: Time.zone.parse("Feb 04 2022 17:00pm"),
              hourly_rate: 21,
            },
            "5" => {
              start_time: nil,
              end_time: nil,
              hourly_rate: 21,
            },
            "6" => {
              start_time: nil,
              end_time: nil,
              hourly_rate: 21,
            },
          },
        },
      }

      post :create, params: params

      expect(assigns(:timesheet).start_date).to eq(Date.parse("Jan 31 2022"))
      expect(assigns(:timesheet).end_date).to eq(Date.parse("Feb 06 2022"))
      expect(assigns(:timesheet).line_items.length).to eq(5)
    end

    context "when the timesheet is invalid" do
      before do
        @timesheet = double(
          "A timesheet",
          persisted?: false,
          errors: double("errors", full_messages: ["Some error messages"]),
        )
        allow(Timesheet).to receive(:new).and_return(@timesheet)
        allow(@timesheet).to receive(:save).and_return(false)
      end

      it "adds error message to the flash" do
        post :create, params: {
          timesheet: {
            start_date: Date.parse("23 Jan 2022"),
            end_date: Date.parse("31 Jan 2022"),
          },
        }

        expect(
          flash[:danger],
        ).to eq("Some error messages")
      end

      it "renders the new view and an error code of unprocessable_entity (422)" do
        post :create, params: {
          timesheet: {
            start_date: Date.parse("23 Jan 2022"),
            end_date: Date.parse("31 Jan 2022"),
          },
        }

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#index" do
    it "assigns all of the current user's timesheets to @timesheets" do
      timesheet_1 = double("Timesheet 1")
      timesheet_2 = double("Timesheet 2")
      current_user = double("user", timesheets: [timesheet_1, timesheet_2])
      allow(controller).to receive(:current_user).and_return(current_user)
      get :index
      expect(assigns(:timesheets)).to eq([timesheet_1, timesheet_2])
    end
  end
end
