class ResponsesController < ApplicationController
  # GET /responses
 def index
   @responses = Response.all
   @json = []

   @responses.each do |response|
    @json << JSON.parse(response.data)
  end

   Tinypass::ClientBuilder.new
   Tinypass.sandbox = true
   Tinypass.aid = ENV['TINYPASS_AID']
   Tinypass.private_key = ENV['TINYPASS_PRIVATE_KEY']

   if (params.has_key?(:data))
     string = params[:data].to_s
     decrypt = Tinypass::SecurityUtils.decrypt(ENV['TINYPASS_PRIVATE_KEY'], params[:data])
     Response.create(data: decrypt)
   end
   render json: @json
 end

 # POST /responses
 def create
   @response = Response.create!(response_params)
   render json: @response
 end

 # GET /responses/:id
 def show
   render json: @response
 end

 # PUT /responses/:id
 def update
   @response.update(response_params)
   head :no_content
 end

 # DELETE /responses/:id
 def destroy
   @response.destroy
   head :no_content
 end

 private

 def response_params
   # whitelist params
   params.permit(:data)
 end

 def set_response
   @response = Response.find(params[:id])
 end
end
