class CustomersController < ApplicationController
  def index

  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customers_path, notice: "#{@customer.name} has been saved."
    else
      flash.now.alert = "Customer could not be saved."
      render :new
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone)
  end
end
