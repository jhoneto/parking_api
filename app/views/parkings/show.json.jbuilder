json.id @parking.id.to_s
json.plate @parking.plate
json.entry_time @parking.entry_time&.iso8601
json.exit_time @parking.exit_time&.iso8601
json.paid @parking.paid
json.created_at @parking.created_at&.iso8601
json.updated_at @parking.updated_at&.iso8601
