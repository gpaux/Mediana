######################################################################################################################

# Function: GenerateReport.
# Argument: ResultDes returned by the CSE function and presentation model and Word-document title and Word-template.
# Description: This function is used to create a summary table with all results
#' @export

GenerateReport.default = function(presentation.model = NULL, cse.results, report.filename, report.template = NULL){
  # Add error checks
  if (!is.null(presentation.model) & class(presentation.model) != "PresentationModel") stop("GenerateReport: the presentation.model parameter must be a PresentationModel object.")
  if (class(cse.results) != "CSE") stop("GenerateReport: the cse.results parameter must be a CSE object.")
  if (!is.character(report.filename)) stop("GenerateReport: the report.filename parameter must be character.")

  # Create the structure of the report
  # If no presentation model, initialize a presentation model object
  if (is.null(presentation.model)) presentation.model = PresentationModel()
  report = CreateReportStructure(cse.results, presentation.model)
  report.results = report$result.structure
  report.structure = report$report.structure

  # Delete an older version of the report
  if (!is.null(report.filename)){
    if (file.exists(report.filename)) file.remove(report.filename)
  }

  # Create a officer::docx object
  doc = officer::read_docx(system.file(package = "Mediana", "template/template.docx"))
  dim_doc = officer::docx_dim(doc)

  # Report's title
  doc = officer::set_doc_properties(doc, title = report.structure$title)
  #title.format = officer::fp_text(font.size = 24, font.family = "Calibri", bold = TRUE)
  doc = officer::body_add_par(doc, value = report.structure$title, style = "TitleDoc")

  # Text formatting
  my.text.format = officer::fp_text(font.size = 11, font.family = "Calibri")

  # Table formatting
  header.cellProperties = officer::fp_cell(border.left = officer::fp_border(width = 0), border.right = officer::fp_border(width = 0), border.bottom = officer::fp_border(width = 2), border.top = officer::fp_border(width = 2), background.color = "#eeeeee")
  data.cellProperties = officer::fp_cell(border.left = officer::fp_border(width = 0), border.right = officer::fp_border(width = 0), border.bottom = officer::fp_border(width = 1), border.top = officer::fp_border(width = 0))

  header.textProperties = officer::fp_text(font.size = 11, bold = TRUE, font.family = "Calibri")
  data.textProperties = officer::fp_text(font.size = 11, font.family = "Calibri")

  leftPar = officer::fp_par(text.align = "left")
  rightPar = officer::fp_par(text.align = "right")
  centerPar = officer::fp_par(text.align = "center")

  # Number of sections in the report (the report's title is not counted)
  n.sections = length(report.structure$section)

  # Loop over the sections in the report
  for(section.index in 1:n.sections) {

    # Section's title (if non-empty)
    if (!is.na(report.structure$section[[section.index]]$title)) doc = officer::body_add_par(doc, value = report.structure$section[[section.index]]$title, style = "heading 1")

    # Number of subsections in the current section
    n.subsections = length(report.structure$section[[section.index]]$subsection)

    # Loop over the subsections in the current section
    for(subsection.index in 1:n.subsections) {

      # Subsection's title (if non-empty)
      if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$title)) doc = officer::body_add_par(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$title, style = "heading 2")

      # Number of subsubsections in the current section
      n.subsubsections = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection)

      if (n.subsubsections>0){
        # Loop over the subsubsection in the current section
        for(subsubsection.index in 1:n.subsubsections) {

          # Subsubsection's title (if non-empty)
          if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$title)) doc = officer::body_add_par(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$title, style = "heading 3")

          # Number of subsubsubsections in the current section
          n.subsubsubsection = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection)

          if (n.subsubsubsection>0){
            # Loop over the subsubsubsection in the current section
            for(subsubsubsection.index in 1:n.subsubsubsection) {

              # Subsubsubsection's title (if non-empty)
              if (!is.na(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$title)) doc = officer::body_add_par(doc, value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$title, style = "heading 4")

              # Number of items in the current subsubsection
              n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item)

              # Loop over the items in the current subsection
              for(item.index in 1:n.items) {

                # Create paragraphs for each item

                # Determine the item's type (text by default)
                type = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$type
                if (is.null(type)) type = "text"

                label = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$label
                value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$value
                param = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$subsubsubsection[[subsubsubsection.index]]$item[[item.index]]$param

                if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

                switch( type,
                        text = {
                          if (label != "") doc = officer::body_add_par(doc, value = paste(label, value), style = "Normal")
                          else  doc = officer::body_add_par(doc, value = value, style = "Normal")
                          doc = flextable::fp_text(my.text.format)
                        },
                        table = {
                          #header.columns = (is.null(param$groupedheader.row))
                          summary_table = flextable::regulartable(data = value)
                          summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = header.cellProperties, pr_t = header.textProperties, part = "header")
                          summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = data.cellProperties, pr_t = data.textProperties, part = "body")

                          if (!is.null(param$span.columns)) {
                            for (ind.span in 1:length(param$span.columns)){
                              summary_table = flextable::merge_v(summary_table, j = param$span.columns[ind.span])
                            }
                          }
                          summary_table = flextable::border(summary_table, inner.vertical = officer::borderNone(),
                                                            outer.vertical = officer::borderNone())
                          if (!is.null(param$groupedheader.row)) {
                            summary_table = flextable::add_header(summary_table, value = param$groupedheader.row$values, colspan = param$groupedheader.row$colspan)
                            summary_table = flextable::add_header(summary_table, value = colnames( value ))
                          }
                          width_table = flextable::dim_pretty(summary_table)$width/(sum(flextable::dim_pretty(summary_table)$width)/(dim_doc$page['width'] - dim_doc$margins['left']/2 - dim_doc$margins['right']/2))
                          summary_table = flextable::autofit(summary_table)
                          summary_table = flextable::width(summary_table, width = width_table)
                          doc = officer::body_add_par(doc, value = label, style = "rTableLegend")
                          doc = flextable::body_add_flextable(doc, summary_table)
                        },
                        plot =  {
                          doc = officer::addPlot(doc, fun = print, x = value, width = 6, height = 5, main = label)
                          doc = officer::body_add_par(doc, value = label, style = "graphic titme")
                        }
                )
              }
            }
          }
          else {
            # Number of items in the current subsubsection
            n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item)

            # Loop over the items in the current subsection
            for(item.index in 1:n.items) {

              # Create paragraphs for each item

              # Determine the item's type (text by default)
              type = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$type
              if (is.null(type)) type = "text"

              label = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$label
              value = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$value
              param = report.structure$section[[section.index]]$subsection[[subsection.index]]$subsubsection[[subsubsection.index]]$item[[item.index]]$param

              if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

              switch( type,
                      text = {
                        if (label != "") doc = officer::body_add_par(doc, value = paste(label, value), style = "Normal")
                        else  doc = officer::body_add_par(doc, value = value, style = "Normal")
                      },
                      table = {
                        header.columns = (is.null(param$groupedheader.row))
                        summary_table = flextable::regulartable(data = value)
                        summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = header.cellProperties, pr_t = header.textProperties, part = "header")
                        summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = data.cellProperties, pr_t = data.textProperties, part = "body")
                        if (!is.null(param$span.columns)) {
                          for (ind.span in 1:length(param$span.columns)){
                            summary_table = flextable::merge_v(summary_table, j = param$span.columns[ind.span])
                          }
                        }
                        # summary_table = flextable::border(summary_table, inner.vertical = officer::borderNone(),
                        #                                 outer.vertical = officer::borderNone())
                        if (!is.null(param$groupedheader.row)) {
                          summary_table = flextable::add_header(summary_table, value = param$groupedheader.row$values, colspan = param$groupedheader.row$colspan)
                          summary_table = flextable::add_header(summary_table, value = colnames( value ))
                        }
                        width_table = flextable::dim_pretty(summary_table)$width/(sum(flextable::dim_pretty(summary_table)$width)/(dim_doc$page['width'] - dim_doc$margins['left']/2 - dim_doc$margins['right']/2))
                        summary_table = flextable::autofit(summary_table)
                        summary_table = flextable::width(summary_table, width = width_table)
                        doc = officer::body_add_par(doc, value = label, style = "rTableLegend")
                        doc = flextable::body_add_flextable(doc, summary_table)
                      },
                      plot =  {
                        doc = officer::body_add_gg(doc, x = value, width = 6, height = 5, main = label)
                        doc = officer::body_add_par(doc, value = label, style = "rPlotLegend")
                      }
              )
            }
          }
        }
      }
      else {

        # Number of items in the current subsection
        n.items = length(report.structure$section[[section.index]]$subsection[[subsection.index]]$item)

        # Loop over the items in the current subsection
        for(item.index in 1:n.items) {

          # Create paragraphs for each item

          # Determine the item's type (text by default)
          type = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$type
          if (is.null(type)) type = "text"

          label = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$label
          value = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$value
          param = report.structure$section[[section.index]]$subsection[[subsection.index]]$item[[item.index]]$param

          if (type == "table" & is.null(param)) param = list(span.columns = NULL, groupedheader.row = NULL)

          switch( type,
                  text = {
                    if (label != "") doc = officer::body_add_par(doc, value = paste(label, value), style = "Normal")
                    else  doc = officer::body_add_par(doc, value = value, style = "Normal")
                  },
                  table = {
                    header.columns = (is.null(param$groupedheader.row))
                    summary_table = flextable::regulartable(data = value)
                    summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = header.cellProperties, pr_t = header.textProperties, part = "header")
                    summary_table = flextable::style(summary_table, pr_p = leftPar, pr_c = data.cellProperties, pr_t = data.textProperties, part = "body")
                    if (!is.null(param$span.columns)) {
                      for (ind.span in 1:length(param$span.columns)){
                        summary_table = flextable::merge_v(summary_table, j = param$span.columns[ind.span])
                      }
                    }
                    # summary_table = flextable::border(summary_table, inner.vertical = officer::borderNone(),
                    #                                 outer.vertical = officer::borderNone())
                    # if (!is.null(param$groupedheader.row)) {
                    #   header = paste0(summary_table$header$col_keys, ' = ', rep(param$groupedheader.row$values, param$groupedheader.row$colspan))
                    #   summary_table = flextable::add_header(summary_table, header)
                    #   summary_table = flextable::add_header(summary_table, value = colnames( value ))
                    # }
                    width_table = flextable::dim_pretty(summary_table)$width/(sum(flextable::dim_pretty(summary_table)$width)/(dim_doc$page['width'] - dim_doc$margins['left']/2 - dim_doc$margins['right']/2))
                    summary_table = flextable::autofit(summary_table)
                    summary_table = flextable::width(summary_table, width = width_table)
                    doc = officer::body_add_par(doc, value = label, style = "rTableLegend")
                    doc = flextable::body_add_flextable(doc, summary_table)
                  },
                  plot =  {
                    doc = officer::body_add_gg(doc, x = value, width = 6, height = 5, main = label)
                    doc = officer::body_add_par(doc, value = label, style = "rPlotLegend")
                  }
          )
        }

      }

    }
  }

  # Save the report
  print(doc, target = report.filename)

  # Return
  return(invisible(report.results))

}
# End of GenerateReport
