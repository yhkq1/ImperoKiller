const year = document.getElementById("year");

const refresh = () => {
    const date = new Date();
    year.innerHTML = `
    <span>
    ${date.getFullYear()}
    </span>
    `;
}

// Optional: Automatisch jedes Jahr aktualisieren
setInterval(refresh, 1000);  // Aktualisiert das Jahr jede Sekunde
