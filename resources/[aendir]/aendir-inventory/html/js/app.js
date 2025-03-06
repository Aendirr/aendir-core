let items = {};
let currentInventory = [];
let currentWeight = 0;
let maxWeight = 0;

// Envanter arayüzünü aç
function openInventory() {
    document.getElementById('inventory').style.display = 'flex';
    document.getElementById('inventory-grid').innerHTML = '';
    updateInventoryDisplay();
}

// Envanter arayüzünü kapat
function closeInventory() {
    document.getElementById('inventory').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeInventory`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Envanter görüntüsünü güncelle
function updateInventoryDisplay() {
    const grid = document.getElementById('inventory-grid');
    grid.innerHTML = '';

    currentInventory.forEach((item, index) => {
        const slot = document.createElement('div');
        slot.className = 'inventory-slot';
        slot.dataset.index = index;

        if (item) {
            const itemData = items[item.name] || { label: 'Bilinmeyen Eşya', image: 'unknown.png' };
            
            slot.innerHTML = `
                <img src="img/items/${itemData.image}" alt="${itemData.label}">
                <div class="item-count">${item.count}</div>
            `;

            slot.addEventListener('click', () => {
                showItemOptions(item, index);
            });
        }

        grid.appendChild(slot);
    });

    updateWeightBar();
}

// Ağırlık çubuğunu güncelle
function updateWeightBar() {
    const weightFill = document.getElementById('weight-fill');
    const currentWeightElement = document.getElementById('current-weight');
    const maxWeightElement = document.getElementById('max-weight');

    const percentage = (currentWeight / maxWeight) * 100;
    weightFill.style.width = `${percentage}%`;

    currentWeightElement.textContent = currentWeight;
    maxWeightElement.textContent = maxWeight;

    if (percentage > 90) {
        weightFill.style.backgroundColor = '#f44336';
    } else if (percentage > 70) {
        weightFill.style.backgroundColor = '#ff9800';
    } else {
        weightFill.style.backgroundColor = '#4CAF50';
    }
}

// Eşya seçeneklerini göster
function showItemOptions(item, index) {
    const options = [
        { label: 'Kullan', action: () => useItem(item, index) },
        { label: 'Transfer Et', action: () => transferItem(item, index) },
        { label: 'Sat', action: () => sellItem(item, index) }
    ];

    // Eşya türüne göre özel seçenekler ekle
    if (item.type === 'weapon') {
        options.push({ label: 'Silahı Çıkar', action: () => unequipWeapon(item, index) });
    }

    // Seçenek menüsünü göster
    showContextMenu(options);
}

// Eşyayı kullan
function useItem(item, index) {
    fetch(`https://${GetParentResourceName()}/useItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            item: item,
            index: index
        })
    });
}

// Eşyayı transfer et
function transferItem(item, index) {
    // Transfer menüsünü göster
    showTransferMenu(item, index);
}

// Eşyayı sat
function sellItem(item, index) {
    fetch(`https://${GetParentResourceName()}/sellItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            item: item,
            index: index
        })
    });
}

// Silahı çıkar
function unequipWeapon(item, index) {
    fetch(`https://${GetParentResourceName()}/unequipWeapon`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            item: item,
            index: index
        })
    });
}

// Bildirim göster
function showNotification(message, type = 'info') {
    const notifications = document.getElementById('notifications');
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <i class="fas ${getNotificationIcon(type)}"></i>
        <span>${message}</span>
    `;

    notifications.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out forwards';
        setTimeout(() => {
            notifications.removeChild(notification);
        }, 300);
    }, 3000);
}

// Bildirim ikonunu al
function getNotificationIcon(type) {
    switch (type) {
        case 'success':
            return 'fa-check-circle';
        case 'error':
            return 'fa-times-circle';
        case 'warning':
            return 'fa-exclamation-circle';
        default:
            return 'fa-info-circle';
    }
}

// İlerleme çubuğunu göster
function showProgress(message) {
    const progressBar = document.getElementById('progress-bar');
    const progressText = progressBar.querySelector('.progress-text');
    progressText.textContent = message;
    progressBar.style.display = 'flex';
}

// İlerleme çubuğunu gizle
function hideProgress() {
    document.getElementById('progress-bar').style.display = 'none';
}

// NUI mesajlarını dinle
window.addEventListener('message', (event) => {
    const data = event.data;

    switch (data.type) {
        case 'openInventory':
            currentInventory = data.inventory;
            currentWeight = data.weight;
            maxWeight = data.maxWeight;
            openInventory();
            break;

        case 'updateInventory':
            currentInventory = data.inventory;
            currentWeight = data.weight;
            maxWeight = data.maxWeight;
            updateInventoryDisplay();
            break;

        case 'showNotification':
            showNotification(data.message, data.notificationType);
            break;

        case 'showProgress':
            showProgress(data.message);
            break;

        case 'hideProgress':
            hideProgress();
            break;
    }
});

// ESC tuşu ile envanteri kapat
document.addEventListener('keyup', (event) => {
    if (event.key === 'Escape') {
        closeInventory();
    }
});

// Sayfa yüklendiğinde eşya verilerini yükle
document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('img/items/items.json');
        items = await response.json();
    } catch (error) {
        console.error('Eşya verileri yüklenirken hata oluştu:', error);
    }
}); 