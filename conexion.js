const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());


mongoose.connect('mongodb://localhost:27017/mi_base')
  .then(() => console.log("✅ Conectado a MongoDB"))
  .catch(err => console.log("❌ Error de conexión:", err));


const usuarioSchema = new mongoose.Schema({
  nombre: {
    type: String,
    required: true
  },
  edad: {
    type: Number,
    required: true
  }
});

const Usuario = mongoose.model('Usuario', usuarioSchema);


app.get('/usuarios', async (req, res) => {
  try {
    const data = await Usuario.find();
    res.json(data);
  } catch (error) {
    res.status(500).json({ mensaje: "Error al obtener usuarios" });
  }
});


app.get('/usuarios/:id', async (req, res) => {
  try {
    const user = await Usuario.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ mensaje: "Error en la búsqueda" });
  }
});


app.post('/usuarios', async (req, res) => {
  try {
    const nuevo = new Usuario(req.body);
    await nuevo.save();

    res.status(201).json(nuevo);
  } catch (error) {
    res.status(400).json({ mensaje: "Error al crear usuario" });
  }
});


app.put('/usuarios/:id', async (req, res) => {
  try {
    const actualizado = await Usuario.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    res.json(actualizado);
  } catch (error) {
    res.status(400).json({ mensaje: "Error al actualizar" });
  }
});


app.delete('/usuarios/:id', async (req, res) => {
  try {
    await Usuario.findByIdAndDelete(req.params.id);
    res.json({ mensaje: "Usuario eliminado" });
  } catch (error) {
    res.status(500).json({ mensaje: "Error al eliminar" });
  }
});


app.listen(3000, () => {
  console.log(" Servidor en http://localhost:3000");
});
