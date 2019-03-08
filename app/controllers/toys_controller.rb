# frozen_string_literal: true

class ToysController < ApplicationController
  def index
    @toys = Toy.all
  end

  def new
    @toy = Toy.new
  end

  def create
    @toy = Toy.new(toy_params)

    if @toy.save
      redirect_to @toy, notice: 'Toy was successfully created.'
    else
      render :new
    end
  end

  def show
    @toy = Toy.find(params[:id])
  end

  def run
    @toy = Toy.find(params[:id])
    commands = params[:command].split

    if commands.length == 2
      last_part = commands.last.split(',')
      @toy.send(commands.first.downcase, *[last_part.first(2).map(&:to_i), last_part.last].flatten)
    else
      @toy.send(commands.first.downcase)
    end

    render layout: false
  end

  private

  def toy_params
    params.require(:toy).permit(:name)
  end
end
