<!-- Content Wrapper -->

<!-- Begin Page Content -->
<div class="container-fluid">

    <!-- Page Heading -->
    <h1 class="h3 mb-4 text-gray-800 text-bold">Selamat Datang</h1>

    <!-- card soal -->
    <a class="col-xl" style="text-decoration:none" href="<?= base_url('admin/soal') ?>">
        <div class="card border-left-primary shadow-sm h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="font-weight-bold text-primary text-uppercase mb-1">
                            Kategori dan Soal</div>
                        <div class="mb-0 text-gray-800">Buat Kategori dan Soal atau upload soal</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </a>

    <!-- card peserta -->
    <a class="mt-2" style="text-decoration:none" href="<?= base_url('admin/peserta') ?>">
        <div class="card border-left-danger shadow-sm h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="font-weight-bold text-danger text-uppercase mb-1">
                            Peserta Ujian</div>
                        <div class="mb-0 text-gray-800">input peserta atau input daftar peserta</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </a>
    <!-- card jadwal -->
    <a class="col-xl" style="text-decoration:none" href="<?= base_url('admin/jadwal') ?>">
        <div class="card border-left-info shadow-sm h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="font-weight-bold text-info text-uppercase mb-1">
                            Jadwal Ujian</div>
                        <div class="mb-0 text-gray-800">create jadwal ujian</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-calendar-alt fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </a>

    <!-- card nilai -->
    <a class="mt-2" style="text-decoration:none" href=" <?= base_url('admin/nilai') ?>">
        <div class="card border-left-success shadow-sm h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="font-weight-bold text-success text-uppercase mb-1">
                            Nilai Ujian</div>
                        <div class="mb-0 text-gray-800">lihat daftar nilai peserta ujian</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-star-half-alt fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </a>

</div>
<!-- /.container-fluid -->
<div id="content"></div>
</div>
<!-- End of Main Content -->

<!-- Footer -->
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span>Copyright &copy;Website 2021</span>
        </div>
    </div>
</footer>
<!-- End of Footer -->

</div>
<!-- End of Content Wrapper -->

</div>
<!-- End of Page Wrapper -->

<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>

<!-- Logout Modal-->
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">yakin untuk keluar?</div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" data-dismiss="modal">batal</button>
                <a class="btn btn-primary" href="<?= base_url('auth/logout'); ?>">keluar</a>
            </div>
        </div>
    </div>