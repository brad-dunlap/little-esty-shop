require 'httparty'

class HolidayService
	def holidays 
		x = get_url("/api/v3/NextPublicHolidays/US")
		x.map do |holiday|
			Holiday.new(holiday)
		end

	end

	def get_url(url)
		response = HTTParty.get("https://date.nager.at#{url}")
		JSON.parse(response.body, symbolize_names: true)
	end
end