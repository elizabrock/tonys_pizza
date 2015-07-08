class MenuItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    @menu_items = MenuItem.all
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      redirect_to menu_items_path, notice: "#{@menu_item.name} (#{number_to_currency(@menu_item.price)}) has been saved."
    else
      flash.now.alert = "Menu item could not be saved."
      render :new
    end
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :image)
  end
end
