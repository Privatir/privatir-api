class NewsletterSubscribeController < ApplicationController
  require 'sendgrid-ruby'
  include SendGrid
  include ActionController::MimeResponds

  def index
    @email = params[:email]
    api_key = Rails.application.credentials.send_grid[:api_key]
    sg = SendGrid::API.new(api_key: api_key)
    mail = SendGrid::Mail.new
    mail.template_id = 'd-23d3c46f7bdc483ca9116bbce32fee72'
    mail.from = SendGrid::Email.new(email: 'info@privatir.com')
    personalization = SendGrid::Personalization.new
    personalization.add_to(Email.new(email: @email))
    mail.add_personalization(personalization)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    logger.debug "The response to the request for the template: #{response.status_code}"
    respond(response) if response.status_code == '202' || response.status_code == '200'
  end

  def respond(response)
    respond_to do |format|
      format.json { render json: { email: @email, status: response.status_code } }
    end
  end
end
