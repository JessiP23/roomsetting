import React, {useRef, useEffect} from "react";
import { View } from "react-native";
import {Renderer, Mesh, TextureLoader, MeshBasicMaterial, BoxGeometry, Scene, PerspectiveCamera, Texture, TextureLoader} from 'three';
import {GLView} from 'expo-gl';
import { texture } from "three/examples/jsm/nodes/Nodes.js";

const ViewRoom = ({ route }) => {
    const { images, dimensions } = route.params;
    const { length, width, height } = dimensions;

    const glViewRef = useRef();

    useEffect(() => {
        const renderRoom = async () => {
            const {current: gl} = glViewRef;
            
            const renderer = new Renderer({ gl });
            renderer.setSize(gl.drawingBufferWidth, gl.drawingBufferHeight);

            const scene = new Scene();
            const camera = new PerspectiveCamera(75, gl.drawingBufferWidth / gl.drawingBufferHeight, 0.1, 1000);
            camera.position.z = 5;

            const geometry = new BoxGeometry(length, height, width);
            const loadTexture = async (uri) => {
                const TextureLoader = new TextureLoader();
                return new Promise((resolve, reject) => {
                    TextureLoader.load(uri, resolve, undefined, reject);
                });
            };

            const materials = await Promise.all([
                loadTexture(images.wall1),
                loadTexture(images.wall2),
                loadTexture(images.wall3),
                loadTexture(images.wall4),
                loadTexture(images.roof),
                loadTexture(images.floor),
            ]).then(textures => textures.map(texture => new MeshBasicMaterial({ map: texture })));

            const room = new Mesh(geometry, materials);
            scene.add(room);

            const animate = () => {
                requestAnimationFrame(animate);
                room.rotation.x += 0.01;
                room.rotation.y += 0.01;
                renderer.render(scene, camera);
                gl.endFrameEXP();
            };

            animate();
        };

        renderRoom();
    }, [images, dimensions]);

    return <GLView style={{ flex: 1 }} ref={glViewRef} onContextCreate={() => {}} />;
};

export default ViewRoom;