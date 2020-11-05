import Rails from '@rails/ujs'

document.addEventListener("turbolinks:load", () => {
  const title = document.querySelector("#tasks_title")
  if (!title) return

  document.querySelector("thead tr").addEventListener("click", (e) => sortTasks(e))

  function sortTasks({target}) {
    Rails.ajax({
      url: `/tasks?order=${target.parentNode.classList[0]}`,
      type: "GET",
      success: function(data){
        document.querySelector("tbody").innerHTML = ""
        data.forEach((taskData) => {
          const task = createTask(taskData)
          document.querySelector("tbody").appendChild(task)
        })
      },
      error: function(errors){
        console.log(errors)
      }
    })
  }

  function createTask({title, start_at, end_at, priority, status, id}) {
    const template = document.querySelector("#task-template")
    const clone = document.importNode(template.content, true)

    clone.querySelector(".title").textContent = title
    let date = new Date(start_at).toLocaleDateString().split("/")
    clone.querySelector(".start_at").textContent = `${date[2]}/${date[0]}/${date[1]}`

    date = end_at ? new Date(end_at).toLocaleDateString().split("/") : ["?", "?", "?"]
    clone.querySelector(".end_at").textContent = `${date[2]}/${date[0]}/${date[1]}`
    clone.querySelector(".priority").textContent = I18n.t("task.priority_option")[priority]
    clone.querySelector(".status").textContent = I18n.t("task.status_option")[status]
    clone.querySelector(".show").href = `/task/${id}`
    clone.querySelector(".edit").href = `/task/${id}/edit`
    clone.querySelector(".delete").href = `/task/${id}`

    return clone
  }
})
