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

      expect(TimesheetLineItem).to receive(:new).exactly(7).times

      get :new

      expect(timesheet.line_items.count).to eq(7)
    end

    it "renders the new Timesheet template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    it "assigns a @timesheet record" do
      post :create, params: { timesheet: { start_date: Date.parse("24 Jan 2022")} }
      expect(assigns(:timesheet)).to be_a(Timesheet)
    end

    it "redirects to a #show action" do
      timesheet = mock_model(Timesheet)
      expect(Timesheet).to receive(:new).and_return(timesheet)
      expect(timesheet).to receive(:save!).and_return(timesheet)
      
      post :create, params: { timesheet: { start_date: Date.parse("24 Jan 2022")} }

      expect(response).to redirect_to(timesheet_url(timesheet))
    end

    it "saves the associated timesheet line items if there are any" do
      Timecop.freeze(Date.parse("Feb 05 2022"))

      params = {
        timesheet: {
          start_date: Date.parse("Jan 31 2022"), 
          end_date: Date.parse("Feb 06 2022"),
          line_items_attributes: {
            '0' => {
              start_time: Time.zone.parse("Jan 31 2022 08:00am"),
              end_time: Time.zone.parse("Jan 31 2022 17:00pm"),
              hourly_rate: 21, 
            }, 
            '1' => {
              start_time: Time.zone.parse("Feb 01 2022 08:00am"),
              end_time: Time.zone.parse("Feb 01 2022 17:00pm"),
              hourly_rate: 21, 
            }, 
            '2' => {
              start_time: Time.zone.parse("Feb 02 2022 08:00am"),
              end_time: Time.zone.parse("Feb 02 2022 17:00pm"),
              hourly_rate: 21, 
            }, 
            '3' => {
              start_time: Time.zone.parse("Feb 03 2022 08:00am"),
              end_time: Time.zone.parse("Feb 03 2022 17:00pm"),
              hourly_rate: 21, 
            }, 
            '4' => {
              start_time: Time.zone.parse("Feb 04 2022 08:00am"),
              end_time: Time.zone.parse("Feb 04 2022 17:00pm"),
              hourly_rate: 21, 
            }, 
            '5' => {
              start_time: nil,
              end_time: nil,
              hourly_rate: 21, 
            }, 
            '6' => {
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
  end
end
