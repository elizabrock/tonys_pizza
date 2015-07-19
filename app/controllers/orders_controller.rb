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
      redirect_to order_path(@order), notice: "#{@order.customer.name}'s order for #{@order.delivery_time.to_s(:long)} has been created."
    else
      flash.now.alert = "The order could not be saved."
      render :new
    end
  end

  def edit
    @customers = Customer.all
    @order = Order.find(params[:id])
  end

  def update
    @customers = Customer.all
    @order = Order.find(params[:id])
    if @order.update_attributes(order_params)
      redirect_to order_path(@order), notice: "#{@order.customer.name}'s order for #{@order.delivery_time.to_s(:long)} has been updated."
    else
      flash.now.alert = "The order could not be updated."
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :delivery_time, :location, :notes)
  end
end
