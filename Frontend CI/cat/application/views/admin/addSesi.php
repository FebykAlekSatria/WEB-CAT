<!-- Begin Page Content -->
<!-- Page Heading -->
<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800 text-bold">Tambah Jadwal</h1>
    <div class="card border-left-primary shadow mx-4">
        <div class="card-body">
            <div class="table-responsive">
                <?= $this->session->flashdata('message'); ?>
                <form class="addSesi ml-auto" method="POST" action="<?= base_url('ImportController/add_sesi') ?>">
                    <div class="form-row col-md-10">
                        <div class="form-group col-md-4">
                            <label>Nama Ujian</label>
                            <input type="text" class="form-control" id="name" name="name" value="<?= set_value('name'); ?>" placeholder="masukkan nama ujian">
                            <?= form_error('name', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                        <div class="form-group col-md-4">
                            <label>Tempat Ujian</label>
                            <input type="text" class="form-control" id="address" name="address" value="<?= set_value('address'); ?>" placeholder="masukkan tempat Ujian">
                            <?= form_error('address', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                    </div>
                    <div class="form-row col-md-10">
                        <div class="form-group col-md-4">
                            <label>Tanggan Ujian</label>
                            <input type="date" class="form-control" id="date" name="date" value="<?= set_value('date'); ?>" placeholder="Email">
                            <?= form_error('date', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                        <div class="form-group col-md-4">
                            <label>Jam ujian</label>
                            <input type="time" class="form-control" id="time" name="time" value="<?= set_value('time'); ?>" placeholder="masukkan jam ujian">
                            <?= form_error('time', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                    </div>
                    <div class="form-row col-md-10">
                        <div class=" form-group col-md-2">
                            <label>Lama Ujian</label>
                            <input type="number" class="form-control" id="durasi" name="durasi" value="<?= set_value('durasi'); ?>" placeholder="menit">
                            <?= form_error('totalPeserta', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                        <div class="form-group col-md-2">
                            <label for="inputCity">Nilai minimum</label>
                            <input type="number" class="form-control" name="score" value="<?= set_value('score'); ?>" placeholder="nilai minimum">
                            <?= form_error('score', '<small class="text-danger pl-3">', '</small>') ?>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="<?= base_url('admin/jadwal') ?>" type="botton" class="btn btn-secondary" data-dismiss="modal">batal</a>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- card soal -->
</div>
<footer class="sticky-footer bg-white">
    <div class="container my-auto">
        <div class="copyright text-center my-auto">
            <span>Copyright &copy;Website 2021</span>
        </div>
    </div>
</footer>
<!-- /.container-fluid -->
</div>
<!-- End of Main Content -->
</div>
<!-- End of Content Wrapper -->
</div>
<!-- End of Page Wrapper -->
<!-- Scroll to Top Button-->
<a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
</a>
