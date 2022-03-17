class NftsController < ApplicationController
  before_action :set_nft, only:[:show, :update, :edit, :destroy]

  def index
    @user = current_user
    if params[:query].present?
      sql_query = "name ILIKE :query OR description ILIKE :query"
      @nfts = policy_scope(Nft).where(sql_query, query: "%#{params[:query]}%")
    else
      @nfts = policy_scope(Nft).order(created_at: :desc)
    end
  end

  def show
    @user = current_user
    @transaction = Transaction.new
    authorize @transaction
    authorize @nft
  end

  def new
    @nft = Nft.new
    authorize @nft
  end

  def create
    @nft = Nft.new(nft_params)
    authorize @nft
    @nft.user = current_user
    if @nft.save
      redirect_to nfts_path
    else
      render "new"
    end
  end

  def update
    authorize @nft
    @nft.update(nft_params)
    redirect_to nft_path(@nft)
  end

  def edit
    authorize @nft
  end

  def destroy
    authorize @nft
    @nft.destroy
    redirect_to nfts_path
  end

  private

  def set_nft
    @nft = Nft.find(params[:id])
  end

  def nft_params
    params.require(:nft).permit(:name, :description, :photo, :published, :price)
  end
  
  # I m just checking if the push origin master is still working after some config
end
