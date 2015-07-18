class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @customers = Customer.all
    @order = Order.new
    if @customers.empty?
      redirect_to orders_path, alert: "Orders cannot be created until customer information has been entered."
    end
  end

  def create
    @customers = Customer.all
    @order = Order.new(order_params)
    if @order.save
      redirect_to order_path(@order), notice: "#{@order.customer.name}'s order has been created."
    else
      flash.now.alert = "The order could not be saved."
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :delivery_time, :location, :notes)
  end
end
