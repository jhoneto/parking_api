class ParkingsController < ApplicationController
  def create
    result = Parking::CreateService.call(plate: parking_params[:plate])

    if result.success?
      render json: { id: result.data.id }, status: :created
    else
      render json: { errors: result.error_message }, status: :unprocessable_entity
    end
  end

  def show
    parkings = Parking.where(plate: params[:id]).order(entry_time: :desc)
    render json: parkings.map { |parking| ParkingSerializer.new(parking).as_json }
  end

  def out
    result = Parking::OutService.call(plate: params[:id])

    if result.success?
      head :ok
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  def pay
    result = Parking::PayService.call(plate: params[:id])

    if result.success?
      head :ok
    else
      render json: { error: result.error_message }, status: :unprocessable_entity
    end
  end

  private

  def parking_params
    params.require(:parking).permit(:plate, :entry_time)
  end
end
