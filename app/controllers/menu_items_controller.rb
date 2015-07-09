class MenuItemsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    @sort_order = params[:sort] || 'name'
    @menu_items = MenuItem.order(@sort_order).all
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

  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  def update
    @menu_item = MenuItem.find(params[:id])
    if @menu_item.update_attributes(menu_item_params)
      redirect_to menu_items_path, notice: "#{@menu_item.name} (#{number_to_currency(@menu_item.price)}) has been updated."
    else
      flash.now.alert = "Your changes could not be saved."
      render :edit
    end
  end

  private

  def menu_item_params
    params.require(:menu_item).permit(:name, :price, :image)
  end
end
