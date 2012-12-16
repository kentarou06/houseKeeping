# -*- coding: utf-8 -*-
class BanksController < ApplicationController
  def newest
    @banks = get_banks
    @banknames = @banks.group('bankname')

    if false
    @banks = Bank.select('bankname').group('bankname')

    @banks.each do |bank|
      bank.putting = Bank.where(:bankname => bank.bankname).sum('putting')
      bank.payment = Bank.where(:bankname => bank.bankname).sum('payment')
    end
    end

    respond_to do |format|
      format.html # newest.html.erb
      format.json { render json: @banks }
      format.xml  { render :xml  => @banks }
    end
  end

  def remainder
    @banks = get_banks

    total_remainder=0
    @banks.each do |bank|
      logger.info("#{bank.year} #{bank.month} #{bank.day}")
      total_remainder = total_remainder + bank.putting if bank.putting != nil
      total_remainder = total_remainder - bank.payment if bank.payment != nil
    end

    render :text => "#{total_remainder}"
  end

  def remove_unneed_record
    @banks = Bank.where('year = 2012 AND month < 10')
    @banks.each do |bank|
      bank.destroy
    end
    render :text => "destoryed record (before 2012.10)"
  end

  def totalize
    @banks = get_banks
    respond_to do |format|
      format.html { render :action => 'index' }
      format.json { render :json => @banks }
      format.xml  { render :xml  => @banks }
    end
  end
  def paykind_list
    @banks = Bank.select('paykind').group('paykind')

    respond_to do |format|
      format.json { render :json => @banks }
      format.xml  { render :xml  => @banks }
    end
  end

  def putkind_list
    @banks = Bank.select('putkind').group('putkind')

    respond_to do |format|
      format.json { render :json => @banks }
      format.xml  { render :xml  => @banks }
    end
  end

  def bank_list
    @banks = Bank.select('bankname').group('bankname')

    respond_to do |format|
      format.json { render :json => @banks }
      format.xml  { render :xml  => @banks }
    end
  end

  def paymoney
    bankname = params[:bankname]

    year = params[:year]
    month = params[:month]
    day = params[:day]

    paykind = params[:paykind]
    payment = params[:payment]
    payreason = params[:payreason]

    s="bankname : #{bankname}<br><br>"
    s="#{s}year  : #{year}<br>"
    s="#{s}month : #{month}<br>"
    s="#{s}day   : #{day}<br><br>"
    s="#{s}paykind : #{paykind}<br>"
    s="#{s}payment : #{payment}<br>"
    s="#{s}payreason : #{payreason}<br>"

    @bank = Bank.new

    @bank.bankname = bankname
    @bank.year = year
    @bank.month = month
    @bank.day = day

    @bank.paykind = paykind
    @bank.payreason = payreason
    @bank.payment = payment

    @bank.putkind = ""
    @bank.putreason = ""
    @bank.putting = ""

    if @bank.save
      s = "success to save to database<br><br>#{s}"
      s = "#{s}<br><br>ID=#{@bank.id}"
    else
      s = "fail to save to database"
    end
    render :text => "#{s}"
  end

  def putmoney
    bankname = params[:bankname]
    year = params[:year]
    month = params[:month]
    day = params[:day]

    putkind = params[:putkind]
    putting = params[:putting]
    putreason = params[:putreason]

    s="bankname : #{bankname}<br><br>"
    s="#{s}year  : #{year}<br>"
    s="#{s}month : #{month}<br>"
    s="#{s}day   : #{day}<br><br>"
    s="#{s}putkind : #{putkind}<br>"
    s="#{s}putting : #{putting}<br>"
    s="#{s}putreason : #{putreason}<br>"

    @bank = Bank.new

    @bank.bankname = bankname
    @bank.year = year
    @bank.month = month
    @bank.day = day

    @bank.paykind = ""
    @bank.payreason = ""
    @bank.payment = ""

    @bank.putkind = putkind
    @bank.putreason = putreason
    @bank.putting = putting

    if @bank.save
      s = "success to save to database<br><br>#{s}"
      s = "#{s}<br><br>ID=#{@bank.id}"
    else
      s = "fail to save to database"
    end
    render :text => "#{s}"
  end


  def check_params(val_name, param)
    if param == nil
      @banks
    else
      @banks.where("#{val_name} = ?", param )
    end
  end

  # return @banks respond to parameter following url
  def get_banks
    @banks = Bank.where('id >= 0')

    @banks = check_params('bankname', params[:bankname])
    @banks = check_params('year', params[:year])
    @banks = check_params('month', params[:month])
    @banks = check_params('day', params[:day])

    @banks = check_params('putkind', params[:putkind])
    @banks = check_params('putreason', params[:putreason])
    @banks = check_params('putting', params[:putting])

    @banks = check_params('paykind', params[:paykind])
    @banks = check_params('payreason', params[:payreason])
    @banks = check_params('payment', params[:payment])

    if params[:group] != nil
      @banks = @banks.group(params[:group])
    end

    @banks.where('id >= 0').order('year ASC, month ASC, day ASC')
  end

  # GET /banks
  # GET /banks.json
  def index
    @banks = get_banks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @banks }
      format.xml  { render :xml  => @banks }
    end
  end

  # GET /banks/1
  # GET /banks/1.json
  def show
    @bank = Bank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/new
  # GET /banks/new.json
  def new
    @bank = Bank.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bank }
    end
  end

  # GET /banks/1/edit
  def edit
    @bank = Bank.find(params[:id])
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(params[:bank])

    respond_to do |format|
      if @bank.save
        format.html { redirect_to @bank, notice: 'Bank was successfully created.' }
        format.json { render json: @bank, status: :created, location: @bank }
      else
        format.html { render action: "new" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /banks/1
  # PUT /banks/1.json
  def update
    @bank = Bank.find(params[:id])

    respond_to do |format|
      if @bank.update_attributes(params[:bank])
        format.html { redirect_to @bank, notice: 'Bank was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank = Bank.find(params[:id])
    @bank.destroy

    respond_to do |format|
      format.html { redirect_to banks_url }
      format.json { head :no_content }
    end
  end
end
