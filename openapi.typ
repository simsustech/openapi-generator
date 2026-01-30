
// headingLevel can be used if you want to include it as an appendix in an existing document
#let openapi(contents, headingLevel: 2) = {
  text()[OpenAPI #contents.openapi]
  linebreak()
  text(2em)[#contents.info.title]
  linebreak()
  text()[v#contents.info.version]
  if ("description" in contents.info) {
    par()[#contents.info.description]
  }
  line(length: 100%)
  heading(level: headingLevel + 1, outlined: false)[Servers]
  for (server) in contents.servers {
    [#server.url]
  }

  heading(level: headingLevel + 1, outlined: false)[Paths]
  for (path, pathValue) in contents.paths {
    heading(level: headingLevel + 2, outlined: false)[#path]
    for (method, methodValue) in pathValue {
      text(weight: "bold")[#methodValue.summary]
      linebreak()
      text()[#methodValue.description]
      v(1em)
      text(weight: "bold")[Tags:]
      list(
        for (tag) in methodValue.tags {
          text()[#tag]
        },
      )

      if ("parameters" in methodValue) {
        heading(level: headingLevel + 3, numbering: none, outlined: false)[Parameters]
        [#methodValue.parameters]
      }

      if ("requestBody" in methodValue) {
        heading(level: headingLevel + 3, numbering: none, outlined: false)[Request body]
        if ("description" in methodValue.requestBody) {
          methodValue.requestBody.description
        }
        linebreak()
        for (key, value) in methodValue.requestBody {
          if (key == "content") {
            for (content, contentValue) in value {
              if ("$ref" in contentValue.schema) {
                [#content: #link(label(contentValue.schema.at("$ref").split("/").at(-1)))[#highlight(fill: blue.lighten(90%), underline(text(fill: blue)[#contentValue.schema.at("$ref").split("/").at(-1)]))
                  ]]
              }
              linebreak()
            }
          }
        }
      }

      if ("responses" in methodValue) {
        heading(level: headingLevel + 3, numbering: none, outlined: false)[Responses]
        for (response, responseValue) in methodValue.responses {
          [#response: #responseValue.description]
          if ("content" in responseValue) {
            list(indent: 1em, marker: none, for (c, cValue) in responseValue.content {
              if ("$ref" in cValue.schema) {
                [#c: #link(label(cValue.schema.at("$ref").split("/").at(-1)))[#highlight(fill: blue.lighten(90%), underline(text(fill: blue)[#cValue.schema.at("$ref").split("/").at(-1)]))
                  ]]
                linebreak()
              }
            })
          }
          linebreak()
        }
      }
    }
  }

  heading(level: headingLevel + 1, outlined: false)[Components]
  heading(level: headingLevel + 2, numbering: none, outlined: false)[Schemas]
  for (schema, schemaValue) in contents.components.schemas {
    heading(level: headingLevel + 3, numbering: none, outlined: false)[#schema #label(schema)]
    [#schemaValue]
  }
}
