$ ->
  # Typeahead
  substringMatcher = (strs) ->
    findMatches = (q, cb) ->
      matches = undefined
      substrRegex = undefined
      # an array that will be populated with substring matches
      matches = []
      # regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, "i")
      # iterate through the pool of strings and for any string that
      # contains the substring `q`, add it to the `matches` array
      $.each strs, (i, str) ->
        # the typeahead jQuery plugin expects suggestions to a
        # JavaScript object, refer to typeahead docs for more info
        matches.push value: str  if substrRegex.test(str)
        return
      cb matches
      return

  schools = [
    "University of the Pacific"
    "California State University, Fresno"
    "Stanford"
    "Harvard"
    "University of California Berkely"
    "University of Southern California"
    "California State University, Long Beach"
    "California State University, Sacramento"
    "New Mexico State University"
    "Azuza Pacific University"
  ]

  # Typeahead Initialize
  $("#school-search .typeahead").typeahead
    hint: true
    highlight: true
    minLength: 1
  ,
    name: "schools"
    displayKey: "value"
    source: substringMatcher(schools)


  # Constructs the suggestion engine
  schools = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace("value")
    queryTokenizer: Bloodhound.tokenizers.whitespace
    local: $.map(schools, (school) ->
      value: school
    )
  )

  # Starts the loading/processing of `local` and `prefetch`
  schools.initialize()

  # Initialize Bloodhound
  $("#bloodhound .typeahead").typeahead
    hint: true
    highlight: true
    minLength: 1
  ,
    name: "schools"
    displayKey: "value"
    # `ttAdapter` wraps the suggestion engine in an adapter that
    # is compatible with the typeahead jQuery plugin
    source: schools.ttAdapter()