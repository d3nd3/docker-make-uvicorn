from html import escape

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse
# from starlette.middleware.cors import CORSMiddleware

"""async def app(scope, receive, send):
    assert scope['type'] == 'http'

    await send({
        'type': 'http.response.start',
        'status': 200,
        'headers': [
            [b'content-type', b'text/html'],
        ]
    })
    debug = f"<br><br>{escape(str(scope))}<br><br>{escape(str(receive))}<br><br>{escape(str(send))}"
    await send({
        'type': 'http.response.body',
        'body': ('''
            <!DOCTYPE html>\n
            <head>\n
                <link rel="stylesheet" href="style.css">
            </head>\n
            <body>\n
            </body>\n
            <p>
            Hello, world, from uvicorn ASGI! hehe
            ''' + debug + "</p>").encode()
    })
"""

app = FastAPI()

app.mount("/static", StaticFiles(directory="/docker-work/uvicornn/appdir/static"), name="static")

# app.add_middleware(
# CORSMiddleware,
# allow_origins=["*"], # Allows all origins
# allow_credentials=True,
# allow_methods=["*"], # Allows all methods
# allow_headers=["*"], # Allows all headers
# )

@app.get("/",response_class=HTMLResponse)
async def catch_all():
    return HTMLResponse(content="""
        <!DOCTYPE html>\n
        <head>\n
            <link rel="stylesheet" href="static/style.css">
            <script src="/static/script.js"></script>
        </head>\n
        <body>\n
        </body>\n
        <p>
        Hello, world, from uvicorn FastAPI!! hehe
        """,status_code=200)


