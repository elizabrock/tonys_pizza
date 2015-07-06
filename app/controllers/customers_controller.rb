class CustomersController < ApplicationController
  def index
    @customers = Customer.order(:name).all
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

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      redirect_to customers_path, notice: "#{@customer.name} has been updated."
    else
      flash.now.alert = "Customer could not be updated."
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :phone)
  end
end
