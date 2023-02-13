from fastapi import FastAPI, HTTPException
import requests
from google.cloud import storage
from pydantic import BaseModel
import uvicorn


app = FastAPI()

class Params(BaseModel):
    url : str
    bucket_name : str
    output_file_prefix : str


# agora vamos começar a criar as rotas
# API funciona baseado em métodos 

@app.get('/') # nesse rota de home
async def read_root():
    return {"Hello" : "World"}

"""
O que queremos que a API faça ?

fonte de dados :
https://dados.gov.br/dados/conjuntos-dados/serie-historica-de-precos-de-combustiveis-por-revenda

precisa bater nesse site em cada um desses arquivos contendo uma url padrão

"""

# vai fazer um get da url que vamos passar:

def get_dados(remote_url):
    response = requests.get(remote_url)


    return response

# essa função vai precisar da rota
# que irá fazer o download dos dados

@app.post("/download_combustivel")
async def download_cumbustivel(params: Params):
    try:

        data = get_dados(params.url)
        
        put_file_to_gcs(
            bucket_name=params.bucket_name,
            output_file=params.output_file_prefix,
            content=data.content
        )

        return {"Status": "OK", "Bucket_name": params.bucket_name, "url": params.url}
    except Exception as ex:
        raise HTTPException(status_code=ex.code, detail=f"{ex}")

# uma função que envie o arquivo recem obtido para nosso bucket raw
# e para isso vamos pegar a função da google que eles fizeram
# só pesquisar por put file in gcs python
# https://cloud.google.com/storage/docs/samples/storage-upload-file?hl=pt-br#storage_upload_file-python

def put_file_to_gcs(output_file: str, bucket_name: str, content):
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        blob = bucket.blob(output_file)
        blob.upload_from_string(content)

        return 'OK'
    except Exception as ex:
        print(ex)

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8080)




