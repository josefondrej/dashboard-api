# Dashboard-API

## Installation

1. Clone this project
2. Run `bundle`
3. Create .env file containing gitlab's `PRIVATE_TOKEN`

 ## Usage

1.  `rails s`
2. In your browser: `localhost:3000/api/v1/SOME_REQUEST`

All available v1 routes can be found under:
`http://0.0.0.0:3000/api/v1/swagger_doc`

### Interactive API browsing

```
rails s -p 9292
open ./dist/index.html
```

## List available routes

`rake grape:routes`
