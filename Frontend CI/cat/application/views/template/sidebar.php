<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <div class="sidebar-brand d-flex align-items-center justify-content-center">
        <div class="sidebar-brand-icon">
        </div>
        <div class="sidebar-brand-text mx-3">Admin</div>
    </div>

    <!-- Nav Item - Dashboard -->
    <li class="nav-item">
        <a class="nav-link" href="<?= base_url('admin') ?>">
            <i class="fas fa-home"></i>
            <span>Dashboard</span></a>
    </li>

    <!-- Nav Item - Charts -->
    <li class="nav-item">
        <a class="nav-link" href="<?= base_url('admin/soal') ?>">
            <i class="fas fa-clipboard-list"></i>
            <span>Kategori dan Soal</span></a>
    </li>

    <!-- Nav Item - Tables -->
    <li class="nav-item">
        <a class="nav-link" href="<?= base_url('admin/peserta') ?>">
            <i class="fas fa-users"></i>
            <span>Peserta Ujian</span></a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="<?= base_url('admin/jadwal') ?>">
            <i class="fas fa-calendar-alt"></i>
            <span>jadwal Ujian</span></a>
    </li>

    <li class="nav-item">
        <a class="nav-link" href="<?= base_url('admin/nilai') ?>">
            <i class="fas fa-star-half-alt"></i>
            <span>Nilai Ujian</span></a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block">

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

</ul>
<!-- End of Sidebar -->