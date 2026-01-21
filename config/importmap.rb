# Pin npm packages by running ./bin/importmap

pin "application"
pin "notyf", to: "https://cdn.jsdelivr.net/npm/notyf@3/notyf.es.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.2/modular/sortable.complete.esm.js"
pin_all_from "app/javascript/controllers", under: "controllers"
