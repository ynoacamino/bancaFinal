addEventListener("load", getCards);

const sections = new Map([
    ["ccn", "Número de cuenta"],
    ["code", "Código de seguridad"],
    ["curr", "Moneda"],
    ["exp-date", "Fecha Exp"]
])

function getCards() {
    fetch2([], [], "lista_tarjetas.pl", function (response) {
        const cards = response.getElementsByTagName("card");
        for (let i = 0; i < cards.length; i++) {
            let id = cards[i].getElementsByTagName("id")[0].childNodes[0].nodeValue;
            let card_number = cards[i].getElementsByTagName("card_number")[0].childNodes[0].nodeValue;
            let code = cards[i].getElementsByTagName("code")[0].childNodes[0].nodeValue;
            let expire_date = cards[i].getElementsByTagName("expire_date")[0].childNodes[0].nodeValue;
            let currency = cards[i].getElementsByTagName("currency")[0].childNodes[0].nodeValue;
            createCardElement([id, card_number, code, currency, expire_date]);
        }
        initCardSlide();
        updateSelectedCard();
    });
}

function createCardElement(values) {
    const cardElement = document.createElement("label");
    cardElement.className = "card mockup";

    const idElement = document.createElement("input");
    idElement.type = "radio";
    idElement.name = "card";
    idElement.id = values[0];
    idElement.value = values[0];
    cardElement.appendChild(idElement);

    createCardSubElement("info", "ccn", values[1], cardElement);
    createCardSubElement("info", "code", values[2], cardElement);
    createCardSubElement("info exp", "curr", values[3], cardElement);
    createCardSubElement("info exp", "exp-date", values[4], cardElement);

    document.getElementById("slide").appendChild(cardElement);
}

function createCardSubElement(cssclass, textId, value, parentElement) {
    const element = document.createElement("div");
    element.className = cssclass;
    const label = document.createElement("label");
    label.innerHTML = sections.get(textId);
    label.setAttribute("for", textId);
    const text = document.createElement("h4");
    text.id = textId;
    text.innerHTML = value;
    element.appendChild(label).appendChild(text);

    parentElement.appendChild(element);
}