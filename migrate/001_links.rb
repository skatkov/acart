Sequel.migration do
  change do
    create_table(:links) do
      primary_key :id
      String :url
    end
  end
end
