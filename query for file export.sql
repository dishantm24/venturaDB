--# Define your SQL query
$query = Select ISINNO from marginreport

# Set the output file path
$outputFile = "D:\FirstAssignment\Book1.csv"

# Define connection details
$server = "your_server"
$database = "your_database"
$username = "your_username"
$password = "your_password"

# Create a connection string
$connectionString = "Server=$172.16.4.199;Database=$venturaDb;User ID=$sa;Password=$Ventura#$123%@;"

# Create a connection object
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)

# Open the connection
$connection.Open()

# Create a command object
$command = $connection.CreateCommand()
$command.CommandText = $query

# Execute the query and retrieve the data
$reader = $command.ExecuteReader()

# Export the data to CSV
$reader | Export-Csv -Path $outputFile -NoTypeInformation

# Close the reader and connection
$reader.Close()
$connection.Close()
