# == Schema Information
#
# Table name: ticket_agencies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key    :string
#

class TicketAgency < ApplicationRecord
end
