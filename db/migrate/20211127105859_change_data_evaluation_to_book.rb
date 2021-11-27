class ChangeDataEvaluationToBook < ActiveRecord::Migration[5.2]
  def change
    change_column :books, :evaluation, :float
  end
end
