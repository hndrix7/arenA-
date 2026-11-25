document.addEventListener("DOMContentLoaded", () => {

    const calendarEl = document.getElementById("calendar");

    const calendar = new FullCalendar.Calendar(calendarEl, {

        locale: "pt-br",

        initialView: "dayGridMonth",

        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek"
        },

        events: [

            {
                title: "Tigres x Leões",
                start: "2026-11-25",
                color: "#014d39"
            },

            {
                title: "Final TUSCA",
                start: "2026-11-30",
                color: "#f59e0b"
            },

            {
                title: "Floripa Chess Open",
                start: "2026-12-05",
                color: "#3b82f6"
            }

        ]

    });

    calendar.render();

});