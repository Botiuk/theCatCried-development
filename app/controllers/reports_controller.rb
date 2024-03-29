class ReportsController < ApplicationController

  def index
    @categories_outcome = Category.reports_formhelper("outcome", current_user.id)
    @categories_income = Category.reports_formhelper("income", current_user.id)
  end

  def report_by_category
    report_data_view
    @diagram_data = Operation.reports_data_by_category(@start_date, @end_date, @otype, @category_id, @user_id).sort
    @cat_name= @diagram_data.map { |e| e[0] }
    @cat_moneys = @diagram_data.map { |e| e[1] }
    @period_sum = Operation.reports_sum(@start_date, @end_date, @otype, @category_id, @user_id)
    @colors = (@diagram_data.size).times.map {"#" + "%06x" % (rand * 0xffffff)}
  end

  def report_by_dates
    report_data_view
    @graph_data = Operation.reports_data_by_dates(@start_date, @end_date, @otype, @category_id, @user_id)
    @dates = @graph_data.map { |e| I18n.l(e[0].to_date, format: :short) }
    @moneys = @graph_data.map { |e| e[1] }
    @period_sum = Operation.reports_sum(@start_date, @end_date, @otype, @category_id, @user_id)
  end

  private

  def report_data_view
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @start_date, @end_date = @end_date, @start_date if @start_date > @end_date
    @otype = params[:otype]
    if @otype == "outcome"
      @category_id = params[:category_id_out]
    else
      @category_id = params[:category_id_in]
    end

    if @category_id != "0"
      @category_name = Category.name_from_id(@category_id)
    end

    @user_id = params[:user_id]
  end

end
