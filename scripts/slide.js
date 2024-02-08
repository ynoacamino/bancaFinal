let selectedIdx = 0;
let idxIdMap = new Map();
let prev;
let next;
let slide;
let cards;
let contentCards;

function initCards() {
  for (let i = 0; i < cards.length; i++) {
    idxIdMap.set(i, cards[i].querySelector(".card-selector").id);
  }
  document.getElementById(idxIdMap.get(selectedIdx)).checked = true;
}

function initSlide() {
  prev = document.querySelector(".prev");
  next = document.querySelector(".next");
  slide = document.querySelector(".slide");
  cards = document.querySelectorAll(".card");
  contentCards = document.querySelector(".cards");

  prev.addEventListener("click", () => {
    slide.scrollLeft -= 400;
    selectedIdx = Math.max(0, Math.min(selectedIdx - 1, cards.length - 1));
    document.getElementById(idxIdMap.get(selectedIdx)).checked = true;
  });

  next.addEventListener("click", () => {
    slide.scrollLeft += 400;
    selectedIdx = Math.max(0, Math.min(selectedIdx + 1, cards.length - 1));
    document.getElementById(idxIdMap.get(selectedIdx)).checked = true;
  });

  /*contentCards.addEventListener("click", () => {
    setTimeout(() => {
      updateSelectedCard();
    }, 300);
  });*/
}

function updateSelectedCard() {
  var containerCenter = slide.scrollLeft + slide.offsetWidth / 2;

  var closestCard;
  var minDistance = Infinity;

  cards.forEach(function (card) {
    var cardCenter = card.offsetLeft + card.offsetWidth / 2;
    var distance = Math.abs(containerCenter - cardCenter);

    if (distance < minDistance) {
      minDistance = distance;
      closestCard = card;
    }
  });

  var inputRadio = closestCard.querySelector("input");
  inputRadio.checked = true;
}

