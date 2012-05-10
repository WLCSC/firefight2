class TagsController < ApplicationController
  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag.ticket, notice: 'Tagged user.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @ticket = @tag.ticket
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to @ticket }
      format.json { head :no_content }
    end
  end
end
