require 'rails_helper'

RSpec.describe TimesheetsController, type: :controller do
  describe '#new' do
    it 'creates a new Timesheet where start_date is the Monday of the current week' do
      Timecop.freeze(Date.parse("Feb 05 2022"))

      expect(Timesheet).to receive(:new).with(
        start_date: Date.parse("Jan 31 2022"), 
        end_date: Date.parse("Feb 06 2022"),
      )
      get :new
    end

    it 'renders the new Timesheet template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
