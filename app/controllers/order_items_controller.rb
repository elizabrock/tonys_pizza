class OrderItemsController < ApplicationController
  def new
    @order = Order.find(params[:order_id])
    @order_item = @order.order_items.build
    @menu_items = MenuItem.all
  end

  def create
    @order = Order.find(params[:order_id])
    @order_item = @order.order_items.build(order_item_params)
    @menu_items = MenuItem.all
    if @order_item.save
      redirect_to order_path(@order), notice: "#{@order_item.menu_item.name} has been added to the order."
    else
      flash.now.alert = "Item could not be added."
      render :new
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:menu_item_id, :quantity)
  end
end
