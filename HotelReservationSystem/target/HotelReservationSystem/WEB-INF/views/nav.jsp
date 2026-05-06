<%-- Shared top navigation partial --%>
<header class="site-header">
  <div class="site-header-inner">
    <a class="brand" href="${pageContext.request.contextPath}/dashboard" aria-label="Hotel Reserve dashboard">
      <span class="brand-mark">HR</span>
      <span class="brand-name">HotelReserve</span>
    </a>

    <nav class="primary-nav" aria-label="Main navigation">
      <a href="${pageContext.request.contextPath}/dashboard"
         class="nav-item ${currentPage == 'dashboard' ? 'active' : ''}">
        <span class="icon">D</span> Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/reservations?action=list"
         class="nav-item ${currentPage == 'list' ? 'active' : ''}">
        <span class="icon">R</span> Reservations
      </a>
      <a href="${pageContext.request.contextPath}/reservations?action=add"
         class="nav-item ${currentPage == 'add' ? 'active' : ''}">
        <span class="icon">+</span> New Booking
      </a>
      <a href="${pageContext.request.contextPath}/reservations?action=search"
         class="nav-item ${currentPage == 'search' ? 'active' : ''}">
        <span class="icon">S</span> Search
      </a>
    </nav>

    <div class="header-actions">
      <span class="currency-pill">LKR</span>
      <a href="${pageContext.request.contextPath}/reservations?action=add" class="btn btn-light btn-sm">Register Booking</a>
    </div>
  </div>
</header>
