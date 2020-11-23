document.addEventListener("turbolinks:load", () => {
  const select2Field = document.querySelector(".select2_field")

  if(!select2Field) return

  $(".select2_field").select2({
    tags: true,
    tokenSeparators: [',', ' '],
  })
})
