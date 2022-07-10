# frozen_string_literal: true

require "rails_helper"

describe "devise/sessions/new", type: :view do
  before do
    @resource = User.new
    @resource_name = :user
    stub_template("devise/shared/_links.html.erb" => "The devise links")
  end

  it "renders a row" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    expect(rendered).to have_css("div.row.justify-content-center")
  end

  it "renders a card" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    expect(rendered).to have_css("div.row div.col-6 div.card.login-card div.card-body")
  end

  it "renders a title" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    page = Capybara.string(rendered)
    card = page.find("div.card")

    expect(card).to have_css("h2.card-header", text: "Log in")
  end

  it "renders a form for signing in" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    page = Capybara.string(rendered)
    card = page.find("div.card-body")
    form = card.find("form")

    expect(form["action"]).to eq("/users/sign_in")
  end

  it "renders the form WITHOUT using turbo" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    page = Capybara.string(rendered)
    card = page.find("div.card-body")
    form = card.find("form")

    expect(form["data-turbo"]).to eq("false")
  end

  it "renders fields for an email, password and rememberance" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    page = Capybara.string(rendered)
    card = page.find("div.card-body")
    form = card.find("form")

    email_label = form.find("label", text: "Email")
    email_field = form.find_field("Email")
    password_label = form.find("label", text: "Password")
    password_field = form.find_field("Password")
    remember_me_label = form.find("label", text: "Remember me")
    remember_me_field = form.find_field("Remember me")

    expect(email_label["class"]).to eq("form-label")
    expect(email_field["type"]).to eq("email")
    expect(email_field["class"]).to eq("form-control")
    expect(password_label["class"]).to eq("form-label")
    expect(password_field["type"]).to eq("password")
    expect(password_field["class"]).to eq("form-control")
    expect(remember_me_field["class"]).to eq("form-check-input")
    expect(remember_me_label["class"]).to eq("form-check-label")
  end

  it "renders some devise links" do
    render template: subject, locals: { resource: @resource, resource_name: @resource_name }

    expect(view).to render_template(partial: "_links")

    page = Capybara.string(rendered)
    expect(page.find(".col-6")).to have_content("The devise links")
  end
end
