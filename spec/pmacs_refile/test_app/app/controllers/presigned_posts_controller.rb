class PresignedPostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params.require(:post).permit(:title, :document, documents_files: []))

    if @post.save
      redirect_to [:normal, @post]
    else
      render :new
    end
  end

  def upload
    if params[:token] == "xyz123"
      if params[:file].size < 100
        File.open(File.join(PmacsRefile.backends["limited_cache"].directory, params[:id]), "wb") do |file|
          file.write(params[:file].read)
        end
        render plain: "token accepted"
      else
        render plain: "too large", status: 413
      end
    else
      render plain: "token rejected", status: 403
    end
  end
end
