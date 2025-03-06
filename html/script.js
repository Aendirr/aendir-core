let currentApp = null;
let phoneNumber = null;

// NUI mesajlarını dinle
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openPhone':
            phoneNumber = data.phoneNumber;
            document.getElementById('phone').style.display = 'block';
            loadApps();
            break;
            
        case 'closePhone':
            document.getElementById('phone').style.display = 'none';
            closeApp();
            break;
            
        case 'incomingCall':
            showIncomingCall(data.number);
            break;
            
        case 'startCall':
            showCallScreen(data.number);
            break;
            
        case 'endCall':
            endCall();
            break;
            
        case 'receiveMessage':
            receiveMessage(data.number, data.message);
            break;
    }
});

// Uygulamaları yükle
function loadApps() {
    const appsGrid = document.querySelector('.apps-grid');
    appsGrid.innerHTML = '';
    
    fetch(`https://${GetParentResourceName()}/getApps`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(apps => {
        apps.forEach(app => {
            const appIcon = document.createElement('div');
            appIcon.className = 'app-icon';
            appIcon.style.backgroundColor = app.color;
            appIcon.innerHTML = `<img src="img/${app.icon}" alt="${app.label}">`;
            appIcon.onclick = () => openApp(app.name);
            appsGrid.appendChild(appIcon);
        });
    });
}

// Uygulama açma
function openApp(appName) {
    currentApp = appName;
    const appContainer = document.getElementById('app-container');
    appContainer.classList.remove('hidden');
    
    // Uygulama içeriğini yükle
    switch(appName) {
        case 'whatsapp':
            loadWhatsApp();
            break;
            
        case 'messages':
            loadMessages();
            break;
            
        case 'phone':
            loadPhone();
            break;
            
        case 'camera':
            loadCamera();
            break;
            
        case 'twitter':
            loadTwitter();
            break;
            
        case 'darkchat':
            loadDarkChat();
            break;
            
        case 'sahibinden':
            loadSahibinden();
            break;
            
        case 'ikinciel':
            loadIkinciEl();
            break;
            
        case 'spotify':
            loadSpotify();
            break;
            
        case 'youtube':
            loadYouTube();
            break;
    }
}

// Uygulama kapatma
function closeApp() {
    currentApp = null;
    const appContainer = document.getElementById('app-container');
    appContainer.classList.add('hidden');
    appContainer.innerHTML = '';
}

// WhatsApp yükleme
function loadWhatsApp() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">WhatsApp</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="chat-list">
            <!-- Sohbetler JavaScript ile eklenecek -->
        </div>
    `;
    
    // Sohbetleri yükle
    fetch(`https://${GetParentResourceName()}/getChats`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(chats => {
        const chatList = appContainer.querySelector('.chat-list');
        chats.forEach(chat => {
            const chatItem = document.createElement('div');
            chatItem.className = 'chat-item';
            chatItem.innerHTML = `
                <div class="chat-avatar"></div>
                <div class="chat-info">
                    <div class="chat-name">${chat.name}</div>
                    <div class="chat-message">${chat.lastMessage}</div>
                </div>
            `;
            chatItem.onclick = () => openChat(chat.number);
            chatList.appendChild(chatItem);
        });
    });
}

// Mesajlar yükleme
function loadMessages() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Mesajlar</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="message-list">
            <!-- Mesajlar JavaScript ile eklenecek -->
        </div>
    `;
    
    // Mesajları yükle
    fetch(`https://${GetParentResourceName()}/getMessages`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(messages => {
        const messageList = appContainer.querySelector('.message-list');
        messages.forEach(message => {
            const messageItem = document.createElement('div');
            messageItem.className = 'message-item';
            messageItem.innerHTML = `
                <div class="message-avatar"></div>
                <div class="message-info">
                    <div class="message-name">${message.name}</div>
                    <div class="message-preview">${message.preview}</div>
                </div>
            `;
            messageItem.onclick = () => openMessage(message.number);
            messageList.appendChild(messageItem);
        });
    });
}

// Telefon yükleme
function loadPhone() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Telefon</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="phone-keypad">
            <div class="keypad-button">1</div>
            <div class="keypad-button">2</div>
            <div class="keypad-button">3</div>
            <div class="keypad-button">4</div>
            <div class="keypad-button">5</div>
            <div class="keypad-button">6</div>
            <div class="keypad-button">7</div>
            <div class="keypad-button">8</div>
            <div class="keypad-button">9</div>
            <div class="keypad-button">*</div>
            <div class="keypad-button">0</div>
            <div class="keypad-button">#</div>
        </div>
        <div class="phone-number"></div>
        <div class="phone-actions">
            <div class="phone-action" onclick="makeCall()">Ara</div>
            <div class="phone-action" onclick="endCall()">Kapat</div>
        </div>
    `;
    
    // Tuş takımı olaylarını dinle
    const keypadButtons = appContainer.querySelectorAll('.keypad-button');
    keypadButtons.forEach(button => {
        button.onclick = () => {
            const number = button.textContent;
            const phoneNumber = appContainer.querySelector('.phone-number');
            phoneNumber.textContent += number;
        };
    });
}

// Kamera yükleme
function loadCamera() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Kamera</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="camera-view"></div>
        <div class="camera-controls">
            <div class="camera-button" onclick="switchCamera()">🔄</div>
            <div class="camera-button" onclick="takePhoto()">📸</div>
            <div class="camera-button" onclick="startVideo()">🎥</div>
        </div>
    `;
}

// Twitter yükleme
function loadTwitter() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Twitter</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="tweet-list">
            <!-- Tweetler JavaScript ile eklenecek -->
        </div>
    `;
    
    // Tweetleri yükle
    fetch(`https://${GetParentResourceName()}/getTweets`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(tweets => {
        const tweetList = appContainer.querySelector('.tweet-list');
        tweets.forEach(tweet => {
            const tweetItem = document.createElement('div');
            tweetItem.className = 'tweet-item';
            tweetItem.innerHTML = `
                <div class="tweet-header">
                    <div class="tweet-avatar"></div>
                    <div class="tweet-info">
                        <div class="tweet-name">${tweet.name}</div>
                        <div class="tweet-handle">@${tweet.handle}</div>
                    </div>
                </div>
                <div class="tweet-content">${tweet.content}</div>
                <div class="tweet-actions">
                    <span>❤️ ${tweet.likes}</span>
                    <span>🔄 ${tweet.retweets}</span>
                    <span>💬 ${tweet.replies}</span>
                </div>
            `;
            tweetList.appendChild(tweetItem);
        });
    });
}

// DarkChat yükleme
function loadDarkChat() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">DarkChat</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="darkchat-list">
            <!-- İlanlar JavaScript ile eklenecek -->
        </div>
    `;
    
    // İlanları yükle
    fetch(`https://${GetParentResourceName()}/getDarkChatListings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(listings => {
        const listingList = appContainer.querySelector('.darkchat-list');
        listings.forEach(listing => {
            const listingItem = document.createElement('div');
            listingItem.className = 'darkchat-item';
            listingItem.innerHTML = `
                <div class="darkchat-header">
                    <div class="darkchat-title">${listing.title}</div>
                    <div class="darkchat-price">$${listing.price}</div>
                </div>
                <div class="darkchat-description">${listing.description}</div>
            `;
            listingList.appendChild(listingItem);
        });
    });
}

// Sahibinden yükleme
function loadSahibinden() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Sahibinden</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="listing-list">
            <!-- İlanlar JavaScript ile eklenecek -->
        </div>
    `;
    
    // İlanları yükle
    fetch(`https://${GetParentResourceName()}/getSahibindenListings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(listings => {
        const listingList = appContainer.querySelector('.listing-list');
        listings.forEach(listing => {
            const listingItem = document.createElement('div');
            listingItem.className = 'listing-item';
            listingItem.innerHTML = `
                <div class="listing-image"></div>
                <div class="listing-title">${listing.title}</div>
                <div class="listing-price">${listing.price} TL</div>
                <div class="listing-details">${listing.details}</div>
            `;
            listingList.appendChild(listingItem);
        });
    });
}

// İkinci El yükleme
function loadIkinciEl() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">İkinci El</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="market-list">
            <!-- İlanlar JavaScript ile eklenecek -->
        </div>
    `;
    
    // İlanları yükle
    fetch(`https://${GetParentResourceName()}/getMarketListings`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).then(response => response.json()).then(listings => {
        const marketList = appContainer.querySelector('.market-list');
        listings.forEach(listing => {
            const marketItem = document.createElement('div');
            marketItem.className = 'market-item';
            marketItem.innerHTML = `
                <div class="market-image"></div>
                <div class="market-title">${listing.title}</div>
                <div class="market-price">${listing.price} TL</div>
                <div class="market-details">${listing.details}</div>
            `;
            marketList.appendChild(marketItem);
        });
    });
}

// Spotify yükleme
function loadSpotify() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">Spotify</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="spotify-player">
            <div class="spotify-cover"></div>
            <div class="spotify-info">
                <div class="spotify-title">Şarkı Adı</div>
                <div class="spotify-artist">Sanatçı</div>
            </div>
            <div class="spotify-controls">
                <div class="spotify-control">⏮️</div>
                <div class="spotify-control">▶️</div>
                <div class="spotify-control">⏭️</div>
            </div>
            <div class="spotify-progress"></div>
            <div class="spotify-time">
                <span>0:00</span>
                <span>3:30</span>
            </div>
        </div>
    `;
}

// YouTube yükleme
function loadYouTube() {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="app-header">
            <div class="app-title">YouTube</div>
            <div class="back-button" onclick="closeApp()">←</div>
        </div>
        <div class="youtube-player">
            <div class="youtube-video"></div>
            <div class="youtube-title">Video Başlığı</div>
            <div class="youtube-info">
                <span>100B görüntüleme</span>
                <span>1 gün önce</span>
            </div>
            <div class="youtube-controls">
                <div class="youtube-control">⏮️</div>
                <div class="youtube-control">▶️</div>
                <div class="youtube-control">⏭️</div>
            </div>
            <div class="youtube-progress"></div>
            <div class="youtube-time">
                <span>0:00</span>
                <span>10:30</span>
            </div>
        </div>
    `;
}

// Arama yapma
function makeCall() {
    const phoneNumber = document.querySelector('.phone-number').textContent;
    if (phoneNumber) {
        fetch(`https://${GetParentResourceName()}/makeCall`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                number: phoneNumber
            })
        });
    }
}

// Arama sonlandırma
function endCall() {
    fetch(`https://${GetParentResourceName()}/endCall`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Gelen arama gösterme
function showIncomingCall(number) {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="incoming-call">
            <div class="caller">${number}</div>
            <div class="call-actions">
                <div class="call-action accept" onclick="answerCall('${number}')">📞</div>
                <div class="call-action reject" onclick="rejectCall('${number}')">❌</div>
            </div>
        </div>
    `;
}

// Arama ekranı gösterme
function showCallScreen(number) {
    const appContainer = document.getElementById('app-container');
    appContainer.innerHTML = `
        <div class="call-screen">
            <div class="caller">${number}</div>
            <div class="call-time">00:00</div>
            <div class="call-actions">
                <div class="call-action" onclick="endCall()">❌</div>
            </div>
        </div>
    `;
}

// Arama cevaplama
function answerCall(number) {
    fetch(`https://${GetParentResourceName()}/answerCall`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            number: number
        })
    });
}

// Arama reddetme
function rejectCall(number) {
    fetch(`https://${GetParentResourceName()}/rejectCall`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            number: number
        })
    });
}

// Mesaj alma
function receiveMessage(number, message) {
    if (currentApp === 'whatsapp' || currentApp === 'messages') {
        // Mesajı ilgili uygulamada göster
        const appContainer = document.getElementById('app-container');
        const messageElement = document.createElement('div');
        messageElement.className = 'message';
        messageElement.innerHTML = `
            <div class="message-content">${message}</div>
            <div class="message-time">${new Date().toLocaleTimeString()}</div>
        `;
        appContainer.appendChild(messageElement);
        appContainer.scrollTop = appContainer.scrollHeight;
    }
}

// ESC tuşu ile telefonu kapatma
document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape') {
        fetch(`https://${GetParentResourceName()}/closePhone`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({})
        });
    }
}); 