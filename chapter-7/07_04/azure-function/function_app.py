import azure.functions as func
from write_blob import wb
from read_blob import rb


app = func.FunctionApp()

app.register_functions(wb)

app.register_functions(rb)
