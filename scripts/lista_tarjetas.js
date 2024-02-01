addEventListener("load", getCards);

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
    idElement.className = "card-selector"
    idElement.name = "card";
    idElement.id = values[0];
    idElement.value = values[0];
    cardElement.appendChild(idElement);

    let number = formatNumber(values[1]);
    let password = formatPassword(values[2]);
    let expire = formatExpire(values[4]);
    createCardSubElement("info", "Número de cuenta", number, cardElement);
    createCardSubElement("info", "Clave", password, cardElement);
    createCardSubElement("info exp", "Moneda", values[3], cardElement);
    createCardSubElement("info exp", "Fecha Exp", expire, cardElement);

    document.getElementById("slide").appendChild(cardElement);
}

function formatNumber(number) {
    let fnumber = number.substring(0, 4);
    for (let i = 1; i <= 3; i++)
        fnumber += "-" + number.substring(i * 4, i * 4 + 4);
    return fnumber;
}

function formatPassword(password) {
    return password.substring(0, 4) + "*".repeat(password.length - 4);
}

function formatExpire(expire) {
    return expire.substring(0, expire.indexOf(" "));
}

function createCardSubElement(cssclass, title, value, parentElement) {
    const element = document.createElement("div");
    element.className = cssclass;

    const titleElement = document.createElement("h6");
    titleElement.innerHTML = title;
    const textElement = document.createElement("h4");
    textElement.innerHTML = value;
    element.appendChild(titleElement)
    element.appendChild(textElement);

    parentElement.appendChild(element);
}

function generateCardsQuery() {
    const cardElements = document.getElementsByName("card");
    const cards = ["card_id"];
    for (let i = 0; i < cardElements.length; i++) {
        cards[i + 1] = cardElements.item(i).value;
    }
    return cards;
}