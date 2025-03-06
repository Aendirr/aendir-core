// Değişkenler
let currentMenu = null;
let currentInventory = [];
let currentWeight = 0;
let maxWeight = 50;
let items = {};

// Eşya Resimleri
async function loadItems() {
    try {
        const response = await fetch('img/items/items.json');
        if (!response.ok) {
            throw new Error('Eşya listesi yüklenemedi');
        }
        items = await response.json();
        console.log('Eşya listesi başarıyla yüklendi:', items);
    } catch (error) {
        console.error('Eşya resimleri yüklenirken hata oluştu:', error);
        showNotification('Eşya listesi yüklenirken bir hata oluştu', 'error');
    }
}

// Eşya Resmi Yükleme
function loadItemImage(itemName) {
    const itemData = items[itemName];
    if (itemData && itemData.image) {
        return `img/items/${itemData.image}`;
    }
    return 'img/items/unknown.png';
}

// Menü Fonksiyonları
function openMenu(menuId) {
    if (currentMenu) {
        closeMenu(currentMenu);
    }
    
    const menu = document.getElementById(menuId);
    menu.classList.add('active');
    currentMenu = menuId;
}

function closeMenu(menuId) {
    const menu = document.getElementById(menuId);
    menu.classList.remove('active');
    currentMenu = null;
}

// Karakter Menüsü
function updateCharacterList(characters) {
    const characterList = document.querySelector('.character-list');
    characterList.innerHTML = '';
    
    characters.forEach(character => {
        const card = document.createElement('div');
        card.className = 'character-card';
        card.innerHTML = `
            <h3>${character.name}</h3>
            <p>Model: ${character.model}</p>
            <p>ID: ${character.citizenid}</p>
            <button onclick="selectCharacter('${character.citizenid}')">Seç</button>
            <button onclick="deleteCharacter('${character.citizenid}')">Sil</button>
        `;
        characterList.appendChild(card);
    });
}

function selectCharacter(citizenid) {
    fetch(`https://${GetParentResourceName()}/selectCharacter`, {
        method: 'POST',
        body: JSON.stringify({
            cid: citizenid
        })
    });
    closeMenu('character-menu');
}

function deleteCharacter(citizenid) {
    if (confirm('Bu karakteri silmek istediğinizden emin misiniz?')) {
        fetch(`https://${GetParentResourceName()}/deleteCharacter`, {
            method: 'POST',
            body: JSON.stringify({
                cid: citizenid
            })
        });
    }
}

// Eşya Detayları
function showItemTooltip(item, x, y) {
    const tooltip = document.createElement('div');
    tooltip.className = 'item-tooltip';
    
    const itemData = items[item.name];
    if (itemData) {
        tooltip.innerHTML = `
            <h4>${itemData.label}</h4>
            <p>Miktar: ${item.amount}</p>
            ${itemData.description ? `<p>${itemData.description}</p>` : ''}
            ${itemData.weight ? `<p>Ağırlık: ${itemData.weight} kg</p>` : ''}
            ${itemData.price ? `<p>Fiyat: $${itemData.price}</p>` : ''}
        `;
    }
    
    tooltip.style.left = `${x}px`;
    tooltip.style.top = `${y}px`;
    
    document.body.appendChild(tooltip);
    return tooltip;
}

// Envanter Menüsü
function updateInventory(items, weight) {
    currentInventory = items;
    currentWeight = weight.current;
    maxWeight = weight.max;
    
    const inventoryGrid = document.querySelector('.inventory-grid');
    inventoryGrid.innerHTML = '';
    
    items.forEach((item, index) => {
        const slot = document.createElement('div');
        slot.className = 'inventory-slot';
        slot.draggable = true;
        slot.dataset.index = index;
        
        const itemData = items[item.name];
        const imagePath = loadItemImage(item.name);
        
        slot.innerHTML = `
            <img src="${imagePath}" alt="${itemData ? itemData.label : 'Bilinmeyen Eşya'}" onerror="this.src='img/items/unknown.png'">
            <div class="item-name">${itemData ? itemData.label : 'Bilinmeyen Eşya'}</div>
            <div class="item-amount">${item.amount}x</div>
        `;
        
        // Tooltip olayları
        let tooltip = null;
        slot.addEventListener('mouseenter', (e) => {
            tooltip = showItemTooltip(item, e.clientX + 10, e.clientY + 10);
        });
        
        slot.addEventListener('mousemove', (e) => {
            if (tooltip) {
                tooltip.style.left = `${e.clientX + 10}px`;
                tooltip.style.top = `${e.clientY + 10}px`;
            }
        });
        
        slot.addEventListener('mouseleave', () => {
            if (tooltip) {
                tooltip.remove();
                tooltip = null;
            }
        });
        
        // Sürükle-bırak olayları
        slot.addEventListener('dragstart', handleDragStart);
        slot.addEventListener('dragend', handleDragEnd);
        slot.addEventListener('dragover', handleDragOver);
        slot.addEventListener('drop', handleDrop);
        
        slot.onclick = () => useItem(item.name);
        inventoryGrid.appendChild(slot);
    });
    
    updateWeightBar();
}

// Sürükle-bırak işleyicileri
let draggedItem = null;

function handleDragStart(e) {
    draggedItem = this;
    this.classList.add('dragging');
}

function handleDragEnd(e) {
    this.classList.remove('dragging');
    draggedItem = null;
}

function handleDragOver(e) {
    e.preventDefault();
    if (this !== draggedItem) {
        this.classList.add('drag-over');
    }
}

function handleDrop(e) {
    e.preventDefault();
    this.classList.remove('drag-over');
    
    if (this !== draggedItem && draggedItem) {
        const fromIndex = draggedItem.dataset.index;
        const toIndex = this.dataset.index;
        
        // Eşyaları değiştir
        fetch(`https://${GetParentResourceName()}/swapItems`, {
            method: 'POST',
            body: JSON.stringify({
                fromIndex: fromIndex,
                toIndex: toIndex
            })
        });
    }
}

function updateWeightBar() {
    const progress = document.querySelector('.weight-progress');
    const currentWeightText = document.querySelector('.current-weight');
    const maxWeightText = document.querySelector('.max-weight');
    
    const percentage = (currentWeight / maxWeight) * 100;
    progress.style.width = `${percentage}%`;
    
    currentWeightText.textContent = currentWeight;
    maxWeightText.textContent = maxWeight;
}

function useItem(itemName) {
    fetch(`https://${GetParentResourceName()}/useItem`, {
        method: 'POST',
        body: JSON.stringify({
            item: itemName
        })
    });
}

// Bildirimler
function showNotification(message, type = 'info') {
    const notifications = document.getElementById('notifications');
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    let icon = '';
    switch (type) {
        case 'success':
            icon = 'check-circle';
            break;
        case 'error':
            icon = 'times-circle';
            break;
        case 'warning':
            icon = 'exclamation-circle';
            break;
        default:
            icon = 'info-circle';
    }
    
    notification.innerHTML = `
        <i class="fas fa-${icon}"></i>
        <span>${message}</span>
    `;
    
    notifications.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => {
            notifications.removeChild(notification);
        }, 300);
    }, 3000);
}

// Progress Bar
function showProgress(message) {
    const progressBar = document.getElementById('progress-bar');
    const progressText = progressBar.querySelector('.progress-text');
    
    progressText.textContent = message;
    progressBar.classList.add('active');
}

function hideProgress() {
    const progressBar = document.getElementById('progress-bar');
    progressBar.classList.remove('active');
}

// Event Listeners
document.addEventListener('keyup', event => {
    if (event.key === 'Escape') {
        if (currentMenu) {
            closeMenu(currentMenu);
        }
    }
});

document.getElementById('character-form').addEventListener('submit', event => {
    event.preventDefault();
    
    const name = document.getElementById('character-name').value;
    const model = document.getElementById('character-model').value;
    
    fetch(`https://${GetParentResourceName()}/createCharacter`, {
        method: 'POST',
        body: JSON.stringify({
            name: name,
            model: model
        })
    });
    
    event.target.reset();
});

// NUI Callbacks
window.addEventListener('message', event => {
    const data = event.data;
    
    switch (data.action) {
        case 'openCharacterMenu':
            updateCharacterList(data.characters);
            openMenu('character-menu');
            break;
            
        case 'closeCharacterMenu':
            closeMenu('character-menu');
            break;
            
        case 'openInventory':
            updateInventory(data.items, data.weight);
            openMenu('inventory-menu');
            break;
            
        case 'closeInventory':
            closeMenu('inventory-menu');
            break;
            
        case 'updateInventory':
            updateInventory(data.items, data.weight);
            break;
            
        case 'openMenu':
            openMenu(data.menu);
            break;
            
        case 'closeMenu':
            closeMenu(data.menu);
            break;
            
        case 'showNotification':
            showNotification(data.message, data.type);
            break;
            
        case 'showProgress':
            showProgress(data.message);
            break;
            
        case 'hideProgress':
            hideProgress();
            break;
    }
});

// Sayfa Yüklendiğinde
document.addEventListener('DOMContentLoaded', () => {
    loadItems();
}); 