const year = document.getElementById("year");
const refresh = () => {
    const date = new Date();
    year.innerHTML = `
    <span>
    ${date.getFullYear()}
    </span>
    `;
}
setInterval(refresh, 1000);
