require "grape-swagger"

module V1
  class Base < Grape::API
    mount V1::Repositories

    add_swagger_documentation(
      api_version: "v1",
      hide_documentation_path: true,
      mount_path: "/api/v1/swagger_doc",
      hide_format: true
    )
  end
end
