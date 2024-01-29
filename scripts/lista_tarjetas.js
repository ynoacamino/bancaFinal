addEventListener("load", getStatus);

function getStatus() {
    fetch2([], [], "lista_tarjetas.pl", function (response) {
        const cards = response.getElementsByTagName("cards");
        for (let i = 0; i < cards.length; i++) {
            let id = cards[i].getElementsByTagName("id")[0].childNodes[0].nodeValue;
            let card_number = cards[i].getElementsByTagName("card_number")[0].childNodes[0].nodeValue;
            let code = cards[i].getElementsByTagName("code")[0].childNodes[0].nodeValue;
            let expire_date = cards[i].getElementsByTagName("expire_date")[0].childNodes[0].nodeValue;
            let currency = cards[i].getElementsByTagName("currency")[0].childNodes[0].nodeValue;
            createMovementElement(id, card_number, code, expire_date, currency);
        }
    });
}

function createMovementElement(amount, type, date) {
    const movementElement = document.createElement("div");
    movementElement.classList.add("movement");

    const amountElement = document.createElement("h5");
    const typeElement = document.createElement("h5");
    const dateElement = document.createElement("h5");
    amountElement.innerHTML = amount;
    typeElement.innerHTML = type;
    dateElement.innerHTML = date;

    movementElement.appendChild(amountElement);
    movementElement.appendChild(typeElement);
    movementElement.appendChild(dateElement);

    document.getElementById("movements").appendChild(movementElement);
}