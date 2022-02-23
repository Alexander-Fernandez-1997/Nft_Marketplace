class NftsController < ApplicationController
  before_action :set_nft, only:[:show, :update, :edit, :destroy]

  def index
    @nfts = policy_scope(Nft).order(created_at: :desc)
  end

  def show
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
    params.require(:nft).permit(:name, :description, :image_url, :published, :price)
  end
end
