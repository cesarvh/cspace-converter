class ProcedureObjectsController < ApplicationController

  def index
    @objects = CollectionSpaceObject.where(category: "Procedure")
      .order_by(:updated_at => 'desc')
      .page params[:page]
  end

  def show
    @object = CollectionSpaceObject.where(category: "Procedure").where(id: params[:id]).first
  end

end
